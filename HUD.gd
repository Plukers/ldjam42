extends CanvasLayer


func _ready():
	pass

func update_score():
	$Score.text = str(Score.score)