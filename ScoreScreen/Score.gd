extends Node2D

func _ready():
	$Animate.interpolate_property($PlayButton, "position", $PlayButton.position, Vector2(704, 700), 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Animate.interpolate_property($Title, "rect_position", $Title.rect_position, Vector2(144, 0), 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Animate.interpolate_property($David, "position", $David.position, Vector2(1700, 576), 60.0, Tween.TRANS_SINE, Tween.EASE_OUT)

	$Animate.start()
	
	var score = Score.score
	
	$Score.text = str(score)
	
	var message = ""
	if score < 100:
		message = "YOU TRIED...."
	elif score < 200:
		message = "YOU DID SOMETHING"
	elif score < 300:
		message = "YOU SAVED SOME LIVES"
	elif score < 400:
		message = "YOU DID WELL!"
	elif score < 500:
		message = "YOU WERE GREAT!"
	elif score < 600:
		message = "YOU ARE FANTASTIC!"
	elif score < 700:
		message = "YOU ARE THE BEST!!!"
	else:
		message = "LIFESAVER OF THE YEAR"
	
	$ScoreTitle.text = message
