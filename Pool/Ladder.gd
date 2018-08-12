extends Node2D


export(int, "top", "bottom", "left", "right") var sprite_number = 1
var top_ladder = preload("res://Assets/Pool/ladder_top.png")
var bottom_ladder = preload("res://Assets/Pool/ladder_bottom.png")
var left_ladder = preload("res://Assets/Pool/ladder_top.png")
var right_ladder = preload("res://Assets/Pool/ladder_bottom.png")
const TOP_LADDER = 1
const BOT_LADDER = 2
const LEFT_LADDER = 3
const RIGHT_LADDER = 4

var walking_target = Vector2()
func _ready():
	match sprite_number:
		TOP_LADDER:
			$Sprite.set_texture(top_ladder)
			walking_target = Vector2()
		BOT_LADDER:
			$Sprite.set_texture(bottom_ladder)
		LEFT_LADDER:
			$Sprite.set_texture(left_ladder)
		RIGHT_LADDER:
			$Sprite.set_texture(right_ladder)
	pass

func _on_body_entered(body):
	body.walking_target 
	body.leave_water()


func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
