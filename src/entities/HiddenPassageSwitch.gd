extends "res://src/entities/Switch.gd"


func _ready():
	connect("state_changed", self, "_on_switch_state_changed")
	

func _on_switch_state_changed(new_state):
	find_node("Gateway").disabled = new_state
		
	if new_state:
		find_node("HoleSprite").hide()
	else:
		find_node("HoleSprite").show()
