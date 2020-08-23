extends Control

var accepting_inputs = false

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	accepting_inputs = true
	
	yield(get_tree().create_timer(10.0), "timeout")
	Game.start()


func _input(event):
	if not accepting_inputs:
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		Game.start()
