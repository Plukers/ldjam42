extends Node2D

export (PackedScene) var Swimmer

var spawn_location
var target_location

var swimmer_collection

var spawn_timer
export var max_spawn_interval = 10
export var bound_interval = 1.5
export var decrease = 0.95

func _ready():
	Score.score = 0
	
	spawn_location = $Spawn/SpawnLocation
	target_location = $Target/TargetLocation
	
	swimmer_collection = $Swimmers
	
	randomize()
	
	spawn_timer = $SpawnTimer
	spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")
	spawn_timer.start()
	$HUD/Progressbar.connect("lost", self, "_on_lost")

func _on_spawn_timer_timeout():
	
	# spawn new swimmer
	spawn_location.set_offset(randi())
	target_location.set_offset(randi())
	
	var swimmer = Swimmer.instance()
	swimmer_collection.add_child(swimmer)
	swimmer.connect("saved", self, "_swimmer_saved")
	swimmer.connect("died", self, "_swimmer_died")
	
	swimmer.position = spawn_location.position
	swimmer.walk_target = target_location.position
	swimmer.goto_water()
	
	# reset timer
	var next_interval = max(bound_interval, max_spawn_interval)
	spawn_timer.wait_time = randi()%int(next_interval)
	spawn_timer.start()
	max_spawn_interval *= decrease

func _on_lost():
	get_tree().change_scene("res://ScoreScreen/Score.tscn")

func _swimmer_saved():
	Score.score += 10
	$HUD.update_score()
	$HUD/Progressbar.decrement()


func _swimmer_died():
	Score.score -= 5
	Score.score = max(0, Score.score)
	$HUD.update_score()
	$HUD/Progressbar.increment()
