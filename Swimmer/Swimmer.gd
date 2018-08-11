extends RigidBody2D

var force_arrow

var selected = false

func _ready():
	$Area2D.connect("input_event", self, "_on_input_event")
	
	force_arrow = $ForceArrow
	force_arrow.visible = false
	
	set_process(true)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		force_arrow.visible = true
		selected = true

func _process(delta):
	if selected:
		if Input.is_action_pressed("select"):
			force_arrow.set_end_pos(get_viewport().get_mouse_position() - self.position)
		else:
			force_arrow.visible = false
			selected = false
			print("Force: ", force_arrow.get_force_vector())
			apply_impulse(Vector2(0, 0),  force_arrow.get_force_vector())
