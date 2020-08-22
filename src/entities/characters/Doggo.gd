extends StaticBody2D

var is_petted = false

onready var animationPlayer = $AnimationPlayer
onready var interaction = $Interaction
onready var sound = $AudioStreamPlayer


func _ready():
	interaction.connect("interaction_started", self, "_on_interaction_started")
	interaction.connect("interaction_ended", self, "_on_interaction_ended")
	
	if is_petted:
		animationPlayer.play("Petted")

func get_state():
	return is_petted
	

func set_state(state):
	is_petted = state


func _on_interaction_started(player):
	is_petted = true
	sound.play()
	animationPlayer.play("Petted")
	player.end_interact(true)
	

func _on_interaction_ended(_player, _answer):
	pass
