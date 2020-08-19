tool
extends "res://src/components/Interaction.gd"


export(String, FILE, "*.tscn") var map_path 
export(String) var entry_name = "Default"
export(bool) var automatic = true
export(bool) var immediate = true


export(String) var question = "ask_next_map"


func _ready():
	connect("interaction_started", self, "_on_interaction_started")
	connect("interaction_ended", self, "_on_interaction_ended")
	

func player_detected(player):
	if automatic:
		if immediate:
			enter_gateway(player)
		else:
			player.interact(self)
	else:
		help_label.show()


func enter_gateway(_player):
	Game.go_to_map(map_path, entry_name)
	
	
func _on_interaction_started(player):
	if immediate:
		player.end_interact(true)
	else:
		Narrator.ask(question)


func _on_interaction_ended(player, answer):
	Narrator.close()
	
	if answer:
		enter_gateway(player)
