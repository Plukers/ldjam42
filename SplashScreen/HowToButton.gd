extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Area2D.connect("input_event", self, "_on_play_click")
	$Area2D.connect("mouse_exited", self, "_on_mouse_exited");

func _on_play_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		$AnimatedSprite.frame = 1
	elif event is InputEventMouseButton and !event.pressed:
		$AnimatedSprite.frame = 0
		get_tree().change_scene("res://TutorialScreen/TutorialScreen.tscn")

func _on_mouse_exited():
	$AnimatedSprite.frame = 0