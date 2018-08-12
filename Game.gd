extends Node2D

export (PackedScene) var Swimmer

var spawn_location
var spawn_timer

func _ready():
	spawn_location = $Spawn/SpawnLocation
	
	spawn_timer = $SpawnTimer
	spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")
	spawn_timer.start()

func _on_spawn_timer_timeout():
	
	# spawn new swimmer
	spawn_location.set_offset(randi())
	var swimmer = Swimmer.instance()
	add_child(swimmer)
	
	swimmer.position = spawn_location.position
	
	var direction_angle = spawn_location.rotation + PI / 2
	direction_angle += rand_range(-PI / 8, PI / 8)
	
	swimmer.walk_direction = Vector2(cos(direction_angle), sin(direction_angle))
	
	# reset timer
	spawn_timer.wait_time = randi()%15
	spawn_timer.start()
