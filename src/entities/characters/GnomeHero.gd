extends "res://src/entities/characters/Player.gd"

const Bomb = preload("res://src/entities/projectiles/Bomb.tscn")


func _ready():
	attack_cooldown = 1

func shot():
	var container = get_parent()
	
	var bomb = Bomb.instance()
	container.add_child(bomb)
	
	var direction = find_node("AnimationTree").get("parameters/Direction/blend_position")
	var target_collision_layer = 128
	
	bomb.shot_in_direction(direction, position, target_collision_layer)
