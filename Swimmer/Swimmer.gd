extends RigidBody2D

enum State {
	GOTO_WATER,
	IN_WATER,
	LEAVE_WATER
}

export var speed = 5.0
export var initial_force_magnitude = 40.0

var force_arrow
var state = State.GOTO_WATER

var selected = false
var walk_target = Vector2()
var initial_force = Vector2()
var threat_level = 0

func _ready():
	$Area2D.connect("input_event", self, "_on_input_event")
	$Area2D.connect("area_entered", self, "_on_area_entered")
	$Move.connect("tween_completed", self, "_on_tween_ended");
	$Timer.connect("timeout", self, "_on_time_out")
	force_arrow = $ForceArrow
	force_arrow.visible = false
	$Timer.wait_time = randi() % 20 + 10
	
	set_process(true)

func goto_water():
	_set_state(State.GOTO_WATER)
	$AnimatedSprite.set_animation("run")

func leave_water():
	_set_state(State.LEAVE_WATER)
	$Move.interpolate_property(self, "position", self.position, walk_target, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Move.start()
	$AnimatedSprite.set_animation("run")
	


func _on_input_event(viewport, event, shape_idx):
	if state == State.IN_WATER and event is InputEventMouseButton and event.pressed:
		force_arrow.visible = true
		selected = true

func _on_area_entered(area):
	if(area.get_collision_layer_bit(Constants.WATER_AREA_LAYER)):
		$Move.stop_all()
		apply_impulse(Vector2(), initial_force)
		_set_state(State.IN_WATER)
		$AnimatedSprite.set_animation("swim")

func _on_tween_ended(object, key):
	print(self, "is freed")
	self.queue_free()

func _on_time_out():
	if(threat_level == 0):
		$AnimatedSprite.set_animation("help_1")
		threat_level += 1
		self.set_collision_layer_bit(Constants.SWIMMER_WANTS_OUT, true)
	elif(threat_level == 1):
		$AnimatedSprite.set_animation("help_2")
		threat_level += 1
	elif(threat_level == 2):
		$AnimatedSprite.set_animation("dead")
		threat_level = -1

func _set_state(new_state):
	match new_state:
		State.GOTO_WATER:
			$Area2D.set_collision_mask_bit(Constants.WATER_AREA_LAYER, true)
			
			self.set_collision_mask_bit(Constants.POOL_BORDER_LAYER, false)
			self.set_collision_mask_bit(Constants.SWIMMER_LAYER, false)
			
			initial_force = (walk_target - self.position).normalized() * initial_force_magnitude
			
			$Move.interpolate_property(self, "position", self.position, walk_target, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Move.start()
			
			state = State.GOTO_WATER
			
		State.IN_WATER:
			$Area2D.set_collision_mask_bit(Constants.WATER_AREA_LAYER, false)
			
			self.set_collision_mask_bit(Constants.POOL_BORDER_LAYER, true)
			self.set_collision_mask_bit(Constants.SWIMMER_LAYER, true)
			
			$Timer.start()
			
			state = State.IN_WATER
			
		State.LEAVE_WATER:
			$Area2D.set_collision_mask_bit(Constants.WATER_AREA_LAYER, false)
			
			self.set_collision_mask_bit(Constants.POOL_BORDER_LAYER, false)
			self.set_collision_mask_bit(Constants.SWIMMER_LAYER, false)
			
			state = State.LEAVE_WATER

func _process(delta):
	if state == State.IN_WATER and selected:
		if Input.is_action_pressed("select"):
			force_arrow.set_end_pos(get_viewport().get_mouse_position() - self.position)
		else:
			force_arrow.visible = false
			selected = false
			apply_impulse(Vector2(0, 0),  force_arrow.get_force_vector())

