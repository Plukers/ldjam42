extends Node2D

var tutorial_scene

func _ready():
	$Area2D.connect("input_event", self, "_on_play_click")
	$Area2D.connect("mouse_exited", self, "_on_mouse_exited");
	tutorial_scene = preload("res://TutorialScreen/TutorialScreen.tscn")
	

func _on_play_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		$AnimatedSprite.frame = 1
	elif event is InputEventMouseButton and !event.pressed:
		$AnimatedSprite.frame = 0
		get_tree().change_scene_to(tutorial_scene)

func _on_mouse_exited():
	$AnimatedSprite.frame = 0