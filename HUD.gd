extends CanvasLayer


func _ready():
	pass

func update_score(score):
	$Score.text = str(score)