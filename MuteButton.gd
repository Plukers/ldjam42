extends ColorRect


func _ready():
	$Button.connect("button_up", self, "_on_button_up")
	
	if(not Settings.sound_on):
		$Button.pressed = true

func _on_button_up():
	if $Button.pressed:
		Settings.sound_on = true
	else:
		Settings.sound_on = false