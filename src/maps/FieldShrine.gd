extends "res://src/maps/Shrine.gd"

func _ready():
	if Game.first_shrine:
		Game.first_shrine = false
		Narrator.show_with_interaction(player, "first_shrine")
