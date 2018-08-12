extends RigidBody2D

enum State {
	SPAWNED,
	GOTO_WATER,
	IN_WATER,
	LEAVE_WATER
}

var force_arrow

var state = State.SPAWNED
var selected = false
var walk_direction = Vector2(0, 0)

func _ready():
	$Area2D.connect("input_event", self, "_on_input_event")
	
	force_arrow = $ForceArrow
	force_arrow.visible = false
	
	set_collision_mask_bit(Constants.POOL_WAIT_LAYER, true)
	set_collision_mask_bit(Constants.POOL_BORDER_LAYER, false)
	set_collision_mask_bit(Constants.SWIMMER_LAYER, true)
	
	set_process(true)

func entered_water():
	set_collision_mask_bit(Constants.POOL_WAIT_LAYER, false)
	set_collision_mask_bit(Constants.POOL_BORDER_LAYER, true)
	set_collision_mask_bit(Constants.SWIMMER_LAYER, true)
	
	state = State.IN_WATER

func leave_water():
	set_collision_mask_bit(Constants.POOL_WAIT_LAYER, false)
	set_collision_mask_bit(Constants.POOL_BORDER_LAYER, false)
	set_collision_mask_bit(Constants.SWIMMER_LAYER, false)
	
	state = State.LEAVE_WATER

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		force_arrow.visible = true
		selected = true

func _process(delta):
	
	match state:
		State.GOTO_WATER:
			print("")
		State.SPAWNED:
			print("")
		State.IN_WATER:
			print("")
		State.LEAVE:
			print("")


	if selected:
		if Input.is_action_pressed("select"):
			force_arrow.set_end_pos(get_viewport().get_mouse_position() - self.position)
		else:
			force_arrow.visible = false
			selected = false
			print("Force: ", force_arrow.get_force_vector())
			apply_impulse(Vector2(0, 0),  force_arrow.get_force_vector())

