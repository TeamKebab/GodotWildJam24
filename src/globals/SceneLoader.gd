extends Node


const LEVELS = {
	"start_screen": "res://src/maps/Start.tscn",
	"win_screen": "res://src/maps/Start.tscn",
	"gameover": "res://src/gui/GameOver.tscn",
	"start": "res://src/maps/Start.tscn",
}

var current_scene


func _ready():
	set_current_scene()
	

func start_screen():
	load_level("start_screen")


func win_screen():
	load_level("win_screen")


func gameover_screen():
	load_level("gameover")


func set_current_scene():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


func load_level(name):
	call_deferred("_deferred_load_level", LEVELS[name])


func _deferred_load_level(path):
	# It is now safe to remove the current scene
	current_scene.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	
