extends Node


signal time_passes
signal day_ended
signal player_hp_changed(hp)


const Player = preload("res://src/entities/characters/Player.tscn")


const START_MAP = "res://src/maps/TestLevel.tscn"

const END_OF_DAY = 300
const ADULT_AGE = int(END_OF_DAY * 0.3)
const ELDER_AGE = int(END_OF_DAY * 0.8)


var hero_dynasty = []
var player =  null
var map_state = {}


var time_of_day: int = 0
var max_hp: int = 20
var hp: int setget , get_hp

onready var timer : Timer = $Timer
onready var scene_loader = $SceneLoader


func _ready():
	timer.connect("timeout", self, "_timer_timeout")


func start():
	time_of_day = 0
	hero_dynasty = []
	map_state = {}
	
	player = Player.instance()
	player.hp.connect("hp_changed", self, "_on_player_hp_changed")
	player.hp.connect("died", self, "_on_player_hp_died")
	
	go_to_map(START_MAP, "Default")


func restart():
	timer.stop()
	start()


func game_over():	
	scene_loader.gameover_screen()
	

func add_hero_to_dynasty(hero):
	hero_dynasty.append(hero.get_info())


func get_hp():
	if player == null or player.hp == null:
		return max_hp
	
	return player.hp.hp


func heal(amount):
	if player == null or player.hp == null:
		return
		
	player.hp.heal(amount)


func pause_day():
	timer.stop()
		

func resume_day():
	timer.start()
	
	
func start_day():
	time_of_day = 0
	timer.start()
	

func end_day():
	emit_signal("day_ended")
	timer.stop()
	start_day()


func go_to_map(map_path, entry_name):	
	timer.stop()
	
	if (scene_loader.current_scene.has_method("get_state")):
		map_state[scene_loader.current_scene.filename] = scene_loader.current_scene.get_state()
		
	scene_loader.load_level(map_path, player, entry_name, map_state)


func _timer_timeout():
	time_of_day += 1
	
	if (time_of_day >= END_OF_DAY):
		time_of_day = 0
		emit_signal("day_ended")
	else:
		emit_signal("time_passes", time_of_day)


func _on_player_hp_changed(new_hp):
	emit_signal("player_hp_changed", new_hp)


func _on_player_hp_died():
	end_day()
