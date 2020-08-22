extends Control


export var accepting_inputs : bool = false
	

func _input(event):
	if not accepting_inputs:
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		Game.restart()


