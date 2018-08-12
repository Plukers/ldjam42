extends RigidBody2D

enum State {
	GOTO_WATER,
	IN_WATER,
	LEAVE_WATER
}

export var speed = 5.0
export var initial_force_magnitude = 30.0

var force_arrow
var state

var selected = false
var walk_target = Vector2()
var initial_force = Vector2()

func _ready():
	$Area2D.connect("input_event", self, "_on_input_event")
	$Area2D.connect("area_entered", self, "_on_area_entered")
	
	force_arrow = $ForceArrow
	force_arrow.visible = false
	
	set_process(true)

func goto_water():
	_set_state(State.GOTO_WATER)

func leave_water():
	_set_state(State.LEAVE_WATER)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		force_arrow.visible = true
		selected = true

func _on_area_entered(area):
	if(area.get_collision_layer_bit(Constants.ENTER_WATER_LAYER)):
		$Move.stop_all()
		apply_impulse(Vector2(), initial_force)
	
	if(area.get_collision_layer_bit(Constants.WATER_AREA_LAYER)):
		_set_state(State.IN_WATER)

func _set_state(state):
	match state:
		State.GOTO_WATER:
			$Area2D.set_collision_mask_bit(Constants.ENTER_WATER_LAYER, true)
			$Area2D.set_collision_mask_bit(Constants.WATER_AREA_LAYER, true)
			
			self.set_collision_mask_bit(Constants.POOL_BORDER_LAYER, false)
			self.set_collision_mask_bit(Constants.SWIMMER_LAYER, false)
			
			initial_force = (walk_target - self.position).normalized() * initial_force_magnitude
			
			$Move.interpolate_property(self, "position", self.position, walk_target, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Move.start()
			
		State.IN_WATER:
			$Area2D.set_collision_mask_bit(Constants.ENTER_WATER_LAYER, false)
			$Area2D.set_collision_mask_bit(Constants.WATER_AREA_LAYER, false)
			
			self.set_collision_mask_bit(Constants.POOL_BORDER_LAYER, true)
			self.set_collision_mask_bit(Constants.SWIMMER_LAYER, true)
			
		State.LEAVE_WATER:
			$Area2D.set_collision_mask_bit(Constants.ENTER_WATER_LAYER, false)
			$Area2D.set_collision_mask_bit(Constants.WATER_AREA_LAYER, false)
			
			self.set_collision_mask_bit(Constants.POOL_BORDER_LAYER, false)
			self.set_collision_mask_bit(Constants.SWIMMER_LAYER, false)

func _process(delta):
	
	if state == State.IN_WATER and selected:
		if Input.is_action_pressed("select"):
			force_arrow.set_end_pos(get_viewport().get_mouse_position() - self.position)
		else:
			force_arrow.visible = false
			selected = false
			print("Force: ", force_arrow.get_force_vector())
			apply_impulse(Vector2(0, 0),  force_arrow.get_force_vector())

