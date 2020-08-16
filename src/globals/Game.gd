extends Node


signal time_passes
signal day_ended


const END_OF_DAY = 30


var hero_dynasty = [

]


var time_of_day: int = 0


onready var timer : Timer = $Timer
onready var scene_loader = $SceneLoader


func _ready():
	timer.connect("timeout", self, "_timer_timeout")
	timer.start()	


func restart():
	timer.stop()
	start_day()
	scene_loader.load_level("start")
	

func add_hero_to_dynasty(hero):
	hero_dynasty.append(hero.get_info())
	

func end_day():
	# todo: return monsters to starting places
	emit_signal("day_ended")
	timer.stop()
	start_day()


func start_day():
	time_of_day = 0
	timer.start()


func game_over():	
	scene_loader.gameover_screen()
	
		
func _timer_timeout():
	time_of_day += 1
	
	if (time_of_day >= END_OF_DAY):
		time_of_day = 0
		emit_signal("day_ended")
	else:
		emit_signal("time_passes", time_of_day)
