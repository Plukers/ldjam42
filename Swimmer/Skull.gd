extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Tween.interpolate_property(self, "position", self.position, self.position + Vector2(0, 250), 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	print(self.position)
	# $Tween.interpolate_property(self, "modulate", , self.position + Vector2(0, 25), 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
