extends "res://src/maps/Shrine.gd"

func _ready():
	if Game.first_shrine:
		Game.first_shrine = false
		interaction.show_narrator(player, "first_shrine")
