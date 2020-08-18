extends Node


onready var entities_container : Node = $YSort


func _ready():
	Game.connect("day_ended", self, "restart")
	Game.resume_day()


func restart():
	for entity in entities_container.get_children():
		if entity.has_method("restart"):
			entity.restart()


func get_state():	
	
	var entities_container = find_node("YSort")
	var states = {}
	
	for entity in entities_container.get_children():
		if entity.name == "Player":
			entities_container.remove_child(entity)
		elif entity.has_method("get_state"):
			states[entity.name] = entity.get_state()
		else:
			states[entity.name] = ""
		
	return states		


func set_state(entities_state):
	var entities_container = find_node("YSort")
	
	if entities_state != null:
		for entity in entities_container.get_children():
			if entities_state.has(entity.name):
				if entity.has_method("set_state"):
					entity.set_state(entities_state[entity.name])
			else:
				entity.queue_free()


func set_player(player, entry):
	var entities_container = find_node("YSort")
	var entries_container = find_node("Entries")
	
	var entry_node : Node
	
	for i in entries_container.get_children():
		var name = i.name
		
		if i.name == entry:
			entry_node = i
			break
	
	if entry_node == null:
		entry_node = entries_container.find_node("Default")
	
	player.position = entry_node.position
	player.face(Vector2.RIGHT.rotated(entry_node.rotation))
	
	entities_container.add_child(player)


