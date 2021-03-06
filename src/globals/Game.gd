extends Node


signal time_passes
signal day_ended
signal player_hp_changed(hp)


const PLAYER_RACES = {
	"human": preload("res://src/entities/characters/HumanHero.tscn"),
	"orc": preload("res://src/entities/characters/OrcHero.tscn"),
	"elf": preload("res://src/entities/characters/ElfHero.tscn"),
	"gnome": preload("res://src/entities/characters/GnomeHero.tscn"),
}


const START_MAP = "res://src/maps/FieldLevel.tscn"

const END_OF_DAY = 80
const ADULT_AGE = int(END_OF_DAY * 0.3)
const ELDER_AGE = int(END_OF_DAY * 0.8)


var hero_dynasty = []
var player =  null
var map_state = {}

var first_shrine = true
var first_multiple_companion_shrine = true
var first_baby = true

var current_music = null

var time_of_day: int = 0
var hp: int setget , get_hp

var rng = RandomNumberGenerator.new()


onready var timer : Timer = $Timer
onready var scene_loader = $SceneLoader
onready var music_player = $MusicPlayer
onready var sound_player = $SoundPlayer

func _ready():
	timer.connect("timeout", self, "_timer_timeout")
	rng.randomize()
	

func tutorial():
	scene_loader.tutorial_screen()
	
	
func start():
	time_of_day = ADULT_AGE - 2
	hero_dynasty = []
	map_state = {}
	
	first_shrine = true
	first_multiple_companion_shrine = true
	first_baby = true
	
	player = create_player()
	
	go_to_map(START_MAP, "Default")
	
	yield(scene_loader, "map_loaded")
	
	Narrator.show_with_interaction(player, "game_start")


func restart():
	timer.stop()
	start()


func win():
	scene_loader.start_screen()
	
	
func game_over():	
	scene_loader.gameover_screen()
	
	
func get_hp():
	if player == null or player.hp == null:
		return 0
	
	return player.hp.hp


func heal(amount):
	if player == null or player.hp == null:
		return
		
	player.hp.heal(amount)


func pause_day():
	timer.stop()
		

func resume_day():
	if scene_loader.current_scene.get("resume_day") == true:
		timer.start()
	
	
func start_day():
	time_of_day = 0
	timer.start()
	

func end_day():
	timer.stop()
	emit_signal("day_ended")


func prepare_day():
	hero_dynasty.append(player.get_info())
	
	if player.has_child():		
		yield(Narrator.show_with_interaction(player, "new_hero"), "completed")
		grow_baby()
	else:
		game_over()
		yield()
		
		
func grow_baby():
	var baby = player.baby
	
	var new_player = create_player(baby.parent, baby.race)
	new_player.position = player.position
	new_player.facing_direction = player.facing_direction
	
	var container = player.get_parent()
	var position = player.get_position_in_parent()
	container.remove_child(player)
		
	player = new_player
	
	container.add_child(player)
	container.move_child(player, position)
	

func create_player(parent = "", race = "human"):
	var new_player = PLAYER_RACES[race].instance()
	
	new_player.init(parent)
	
	new_player.hp.connect("hp_changed", self, "_on_player_hp_changed")
	new_player.hp.connect("died", self, "_on_player_hp_died")
	new_player.connect("got_baby", self, "_on_player_got_baby")
	
	emit_signal("player_hp_changed", new_player.hp.max_hp)
	
	return new_player
	
		
func go_to_map(map_path, entry_name):	
	pause_day()
	
	if (scene_loader.current_scene.has_method("get_state")):
		map_state[scene_loader.current_scene.filename] = scene_loader.current_scene.get_state()
		
	scene_loader.load_level(map_path, player, entry_name, map_state)	
	
	yield(scene_loader, "map_loaded")
	
	resume_day()
	

func play_music(music):
	if music == null:
		return
		
	var current_music = music_player.stream
	
	if music != current_music:
		music.set_loop(true)
		music_player.stream = music
		music_player.play()
	
	
func _timer_timeout():
	time_of_day += 1
	
	if (time_of_day >= END_OF_DAY):
		end_day()
	else:
		emit_signal("time_passes", time_of_day)


func _on_player_hp_changed(new_hp):
	emit_signal("player_hp_changed", new_hp)


func _on_player_hp_died():
	end_day()


func _on_player_got_baby(race):
	var message = "got_baby_" + race
	if first_baby:
		first_baby = false
		message = "first_baby"
		
	Narrator.show_with_interaction(player, message)
