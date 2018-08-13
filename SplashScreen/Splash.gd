extends Node2D

func _ready():
	$Animate.interpolate_property($David, "position", $David.position, Vector2(448, 576), 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Animate.interpolate_property($PlayButton, "position", $PlayButton.position, Vector2(976, 576), 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Animate.interpolate_property($Title, "rect_position", $Title.rect_position, Vector2(144, 0), 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	
	
	$Animate.start()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
