extends "res://src/maps/Level.gd"


onready var switch = find_node("Switch")


func _ready():
	switch.connect("state_changed", self, "_on_switch_toggled")
	
	
func _on_switch_toggled(on):
	var map_value = 0
	
	if on:
		map_value = 0
	else:
		map_value = -1
		
	var tiles = [
		Rect2(4, -35, 2, 1),
		Rect2(5, -36, 2, 1),
		Rect2(6, -37, 2, 1),
		Rect2(7, -38, 2, 1),
		Rect2(8, -39, 2, 1),
	]
	
	for rect in tiles:
		set_map("Ground", rect, map_value)
