extends Control

signal lost()

var happy = Constants.HAPPY_BAR
var dieded = Constants.SKULL_BAR

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func increment():
	$HBoxContainer/TextureProgress.value += dieded
	if($HBoxContainer/TextureProgress.value >= 100):
		emit_signal("lost")

func decrement():
	$HBoxContainer/TextureProgress.value += happy

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
