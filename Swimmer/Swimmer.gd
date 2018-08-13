extends RigidBody2D

signal saved()
signal died()

enum State {
	GOTO_WATER,
	IN_WATER,
	LEAVE_WATER
}
enum Status {
	HAPPY,
	WANTS_OUT,
	REALLY_WANTS_OUT,
	HE_DEAD
	}
enum Sound {
	DIE,
	COLLIDE,
	JUMP,
	SAVE,
	CLICK_DOWN,
	CLICK_RELEASE,
	HELP,
	HELP_HELP
	}

var skull = preload("res://Swimmer/Skull.tscn")
var happy = preload("res://Swimmer/Happy.tscn")

var collide_0 = preload("res://Assets/Swimmer/collide_0.wav")
var collide_1 = preload("res://Assets/Swimmer/collide_1.wav")
var save_0 = preload("res://Assets/Swimmer/save_0.wav")
var die_0 = preload("res://Assets/Swimmer/die_0.wav")
var die_1 = preload("res://Assets/Swimmer/die_1.wav")
var die_2 = preload("res://Assets/Swimmer/die_2.wav")
var jump_0 = preload("res://Assets/Swimmer/jump_0.wav")
var jump_1 = preload("res://Assets/Swimmer/jump_1.wav")
var jump_2 = preload("res://Assets/Swimmer/jump_2.wav")
var help_0 = preload("res://Assets/Swimmer/help_0.wav")
var help_1 = preload("res://Assets/Swimmer/help_1.wav")
var help_help_0 = preload("res://Assets/Swimmer/help_help_0.wav")
var help_help_1 = preload("res://Assets/Swimmer/help_help_1.wav")
var click_down = preload("res://Assets/Swimmer/click_down_0.wav")
var click_release = preload("res://Assets/Swimmer/click_release_0.wav")

export var speed = 5.0
export var initial_force_magnitude = 40.0

var force_arrow
var state = State.GOTO_WATER

var selected = false
var walk_target = Vector2()
var initial_force = Vector2()
var status = Status.HAPPY


func _ready():
	$Area2D.connect("input_event", self, "_on_input_event")
	$Area2D.connect("area_entered", self, "_on_area_entered")
	$Move.connect("tween_completed", self, "_on_tween_ended")
	$Timer.connect("timeout", self, "_on_time_out")
	self.connect("body_entered", self, "_on_collision_swimmer")

	force_arrow = $ForceArrow
	force_arrow.visible = false
	
	set_process(true)

func goto_water():
	_set_state(State.GOTO_WATER)
	$AnimatedSprite.set_animation("run")

func leave_water():
	_set_state(State.LEAVE_WATER)
	$Move.interpolate_property(self, "position", self.position, walk_target, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Move.start()
	$AnimatedSprite.set_animation("run")
	var happy_instance = happy.instance()
	happy_instance.translate(Vector2(0, -40))
	self.add_child(happy_instance)
	$Timer.stop()
	_play_sound(Sound.SAVE)
	

func _play_sound(sound):
	match sound:
		Sound.COLLIDE:
			match randi()%1:
				0:
					$Audio.stream = collide_0
				1:
					$Audio.stream = collide_1
		Sound.DIE:
			match randi()%2:
				0:
					$Audio.stream = die_0
				1:
					$Audio.stream = die_1
				2:
					$Audio.stream = die_2
		Sound.SAVE:
			$Audio.stream = save_0
		Sound.JUMP:
			match randi()%2:
				0:
					$Audio.stream = jump_0
				1:
					$Audio.stream = jump_1
				2:
					$Audio.stream = jump_2
		Sound.HELP:
			match randi()%1:
				0:
					$Audio.stream = help_0
				1:
					$Audio.stream = help_1
		Sound.HELP_HELP:
			match randi()%1:
				0:
					$Audio.stream = help_help_0
				1:
					$Audio.stream = help_help_1
		Sound.CLICK_DOWN:
			$Audio.stream = click_down
		Sound.CLICK_RELEASE:
			$Audio.stream = click_release
	$Audio.play()

func _on_input_event(viewport, event, shape_idx):
	if state == State.IN_WATER and status != Status.HE_DEAD and event is InputEventMouseButton and event.pressed:
		force_arrow.visible = true
		selected = true
		_play_sound(Sound.CLICK_DOWN)

func _on_collision_swimmer(body):
	print("something collided!!")
	if(body.get_type() == "RigidBody2D"):
		_play_sound(Sound.COLLIDE)

func _on_area_entered(area):
	if(area.get_collision_layer_bit(Constants.WATER_AREA_LAYER)):
		$Move.stop_all()
		apply_impulse(Vector2(), initial_force)
		_set_state(State.IN_WATER)
		$AnimatedSprite.set_animation("swim")
		_play_sound(Sound.JUMP)

func _on_tween_ended(object, key):
	self.queue_free()

func _on_time_out():
	if(status == Status.HAPPY):
		$AnimatedSprite.set_animation("help_1")
		status += 1
		self.set_collision_layer_bit(Constants.SWIMMER_WANTS_OUT, true)
		_play_sound(Sound.HELP)
		
		$Timer.wait_time = randi() % 7 + 2
		$Timer.start()
	elif(status == Status.WANTS_OUT):
		$AnimatedSprite.set_animation("help_2")
		_play_sound(Sound.HELP_HELP)
		status += 1
		
		$Timer.wait_time = randi() % 7 + 2
		$Timer.start()
	elif(status == Status.REALLY_WANTS_OUT):
		$AnimatedSprite.set_animation("dead")
		self.set_collision_layer_bit(Constants.SWIMMER_WANTS_OUT, false)
		status += 1
		var skull_instance = skull.instance()
		skull_instance.translate(Vector2(0, -40))
		self.add_child(skull_instance)
		_play_sound(Sound.DIE)
		emit_signal("died")

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
			
			
			$Timer.wait_time = randi() % 15 + 2
			$Timer.start()
			
			state = State.IN_WATER
			
		State.LEAVE_WATER:
			$Area2D.set_collision_mask_bit(Constants.WATER_AREA_LAYER, false)
			
			self.set_collision_mask_bit(Constants.POOL_BORDER_LAYER, false)
			self.set_collision_mask_bit(Constants.SWIMMER_LAYER, false)
			
			force_arrow.visible = false
			
			emit_signal("saved")
			
			state = State.LEAVE_WATER

func _process(delta):
	if state == State.IN_WATER and selected:
		if Input.is_action_pressed("select"):
			force_arrow.set_end_pos(get_viewport().get_mouse_position() - self.position)
		else:
			force_arrow.visible = false
			selected = false
			apply_impulse(Vector2(0, 0),  force_arrow.get_force_vector())
			_play_sound(Sound.CLICK_RELEASE)

