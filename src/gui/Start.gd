extends Control

export(AudioStreamOGGVorbis) var music


var accepting_inputs = false

func _ready():
	Game.play_music(music)
	
	yield(get_tree().create_timer(0.2), "timeout")
	accepting_inputs = true
	

func _input(event):
	if not accepting_inputs:
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		Game.tutorial()
