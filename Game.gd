extends Node2D

export (PackedScene) var Swimmer

var spawn_location
var target_location

var swimmer_collection

var spawn_timer

func _ready():
	spawn_location = $Spawn/SpawnLocation
	target_location = $Target/TargetLocation
	
	swimmer_collection = $Swimmers
	
	spawn_timer = $SpawnTimer
	spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")
	spawn_timer.start()

func _on_spawn_timer_timeout():
	
	# spawn new swimmer
	spawn_location.set_offset(randi())
	target_location.set_offset(randi())
	
	var swimmer = Swimmer.instance()
	swimmer_collection.add_child(swimmer)
	
	swimmer.position = spawn_location.position
	swimmer.walk_target = target_location.position
	swimmer.goto_water()
	
	# reset timer
	spawn_timer.wait_time = randi()%15
	spawn_timer.start()
