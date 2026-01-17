extends Label

func _process(_delta):
	if Globals:
		text = "Attempt: " + str(Globals.attempts)
	else:
		text = "Attempt: 1"
