extends StaticBody2D


func set_state(_state):
	create_exit_point()
	
	
func create_exit_point():
	var entry = Node2D.new()
	
	entry.position = position + find_node("Gateway").position
	entry.position.y += 20
	entry.rotation = PI/2
	entry.name = name
	
	var entries = find_parent("Level").find_node("Entries")
	entries.add_child(entry, true) 
