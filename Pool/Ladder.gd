extends Node2D


export(int, "top", "bottom", "left", "right") var sprite_number = 1
var top_ladder = preload("res://Assets/Pool/ladder_top.png")
var bottom_ladder = preload("res://Assets/Pool/ladder_bottom.png")
var left_ladder = preload("res://Assets/Pool/ladder_top.png")
var right_ladder = preload("res://Assets/Pool/ladder_bottom.png")
func _ready():
	match sprite_number:
		1:
			$Sprite.set_texture(top_ladder)
		2:
			$Sprite.set_texture(bottom_ladder)
		3:
			$Sprite.set_texture(left_ladder)
		4:
			$Sprite.set_texture(right_ladder)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
