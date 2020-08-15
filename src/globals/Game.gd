extends Node


signal time_passes
signal day_ended


const END_OF_DAY = 5

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
	time_of_day = 0
	timer.start()
	scene_loader.load_level("start")
	

func game_over(player):
	hero_dynasty.append(player.get_info())
	scene_loader.gameover_screen()
	
	
func _timer_timeout():
	time_of_day += 1
	
	if (time_of_day >= END_OF_DAY):
		time_of_day = 0
		emit_signal("day_ended")
	else:
		emit_signal("time_passes", time_of_day)
