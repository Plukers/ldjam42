extends Node2D


export(int, "top", "bottom", "left", "right") var sprite_number = 0
var top_ladder = preload("res://Assets/Pool/ladder_top.png")
var bottom_ladder = preload("res://Assets/Pool/ladder_bottom.png")
var left_ladder = preload("res://Assets/Pool/ladder_left.png")
var right_ladder = preload("res://Assets/Pool/ladder_right.png")

const TOP_LADDER = 0
const BOT_LADDER = 1
const LEFT_LADDER = 2
const RIGHT_LADDER = 3

var walk_target = Vector2()
func _ready():
	match sprite_number:
			TOP_LADDER:
				$Sprite.texture = top_ladder
			BOT_LADDER:
				$Sprite.texture = bottom_ladder
			LEFT_LADDER:
				$Sprite.texture = left_ladder
			RIGHT_LADDER:
				$Sprite.texture = right_ladder
	
	$Area2D.connect("body_entered", self, "_on_body_entered")
	

func _on_body_entered(body):
	match sprite_number:
		TOP_LADDER:
			body.walk_target = Vector2(randi()%600 + 400, randi()%200 - 400)
		BOT_LADDER:
			body.walk_target = Vector2(randi()%600 + 400, randi()%300 + 1100)
		LEFT_LADDER:
			body.walk_target = Vector2(randi()%200 - 400, randi()%500 + 200)
		RIGHT_LADDER:
			body.walk_target = Vector2(randi()%200 + 1500, randi()%500 + 200)
	
	print(body.walk_target, " walk target by ladder: ", sprite_number)
	body.leave_water()
	
	print(body, "something entered ladder")


func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
