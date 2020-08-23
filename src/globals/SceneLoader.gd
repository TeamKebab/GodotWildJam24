extends Node


signal map_loaded(path)


const SCREENS = {
	"start_screen": "res://src/gui/Start.tscn",
	"tutorial_screen": "res://src/gui/Controls.tscn",
	"win_screen": "res://src/maps/TestLevel.tscn",
	"gameover": "res://src/gui/GameOver.tscn",
}


var current_scene


func _ready():
	set_current_scene()
	

func start_screen():
	call_deferred("_deferred_load_screen", "start_screen")


func tutorial_screen():
	call_deferred("_deferred_load_screen", "tutorial_screen")
	
	
func win_screen():
	call_deferred("_deferred_load_screen", "win_screen")


func gameover_screen():
	call_deferred("_deferred_load_screen", "gameover")

	
func set_current_scene():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


func load_level(path, player, entry, map_state):
	call_deferred("_deferred_load_level", path, player, entry, map_state)


func _deferred_load_level(path, player, entry, map_state):
	current_scene.free()
		
	var s = ResourceLoader.load(path)
	current_scene = s.instance()

	if map_state.has(path):
		current_scene.set_state(map_state[path])
	
	current_scene.set_player(player, entry)
		
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	
	emit_signal("map_loaded", path)
	

func _deferred_load_screen(name):
	current_scene.free()
		
	var s = ResourceLoader.load(SCREENS[name])
	current_scene = s.instance()

	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
