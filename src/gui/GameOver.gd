extends Control


var accepting_inputs : bool = false


onready var timer : Timer = $Timer


func _ready():
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start(5)
	

func _input(event):
	if not accepting_inputs:
		return
		
	if event is InputEventKey and event.pressed:
		Game.restart()


func _on_timer_timeout():
	accepting_inputs = true
