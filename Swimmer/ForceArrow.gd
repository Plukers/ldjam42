extends Node2D

export var max_force = 200
export var force_scale = 3.0

var line

func _ready():
	line = $Line2D

func set_end_pos(pos):
	var length = pos.length()
	
	if length > max_force:
		line.set_point_position(1, pos.normalized() * max_force)
	else:
		line.set_point_position(1, pos)

func get_force_vector():
	return force_scale * (line.get_point_position(0) - line.get_point_position(1))