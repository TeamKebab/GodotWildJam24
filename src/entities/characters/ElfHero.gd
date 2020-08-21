extends "res://src/entities/characters/Player.gd"


const Arrow = preload("res://src/entities/projectiles/Arrow.tscn")


func shot():
	var container = get_parent()
	
	var arrow = Arrow.instance()
	container.add_child(arrow)
	
	var direction = find_node("AnimationTree").get("parameters/Direction/blend_position")
	var target_collision_layer = 128
	
	arrow.shot_in_direction(direction, position, target_collision_layer)
