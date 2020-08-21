tool
extends "res://src/components/Interaction.gd"


export var text = "WARNING!"


func _ready():
	connect("interaction_started", self, "_on_interaction_started")
	connect("interaction_ended", self, "_on_interaction_ended")
	

func _on_interaction_started(_player):
	Narrator.show(text)


func _on_interaction_ended(_player, _answer):
	Narrator.close()
