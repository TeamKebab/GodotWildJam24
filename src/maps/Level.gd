
extends Node


export var resume_day: bool = true


var player = null


onready var entities_container : Node = $YSort


func _ready():
	Game.connect("day_ended", self, "restart")
	
	set_navigation_shape()
		
		
func restart():
	for entity in entities_container.get_children():
		if entity.has_method("restart"):
			entity.restart()


func get_state():	
	
	var entities = find_node("YSort")
	var states = {}
	
	for entity in entities.get_children():
		if entity.name == "Player":
			entities.remove_child(entity)
		elif entity.has_method("get_state"):
			states[entity.name] = entity.get_state()
		else:
			states[entity.name] = ""
		
	return states		


func set_state(entities_state):
	var entities = find_node("YSort")
	
	if entities_state != null:
		for entity in entities.get_children():
			if entities_state.has(entity.name):
				if entity.has_method("set_state"):
					entity.set_state(entities_state[entity.name])
			else:
				entity.queue_free()


func set_player(new_player, entry):
	player = new_player
	
	var entries_container = find_node("Entries")
	
	var entry_node : Node
	
	for i in entries_container.get_children():
		if i.name == entry:
			entry_node = i
			break
	
	if entry_node == null:
		entry_node = entries_container.find_node("Default")
	
	player.position = entry_node.position
	player.face(Vector2.RIGHT.rotated(entry_node.rotation))
	
	find_node("YSort").add_child(player)


func set_navigation_shape():
	var nav_tile_map = $Navigation2D/NavTileMap
	var ground  = $Navigation2D/Ground
	var walls = $Navigation2D/Walls
	
	var ground_cells = ground.get_used_cells()
	
	for cell in ground_cells:
		nav_tile_map.set_cell(cell.x, cell.y, 0)
	
	var wall_cells = walls.get_used_cells()	
	
	for cell in wall_cells:
		nav_tile_map.set_cell(cell.x, cell.y, -1)
		
	nav_tile_map.update_dirty_quadrants()	



