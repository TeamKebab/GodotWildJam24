extends "res://src/maps/Level.gd"


export var heal_amount = 1

onready var heal_timer: Timer = $HealTimer


func _ready():
	Game.pause_day()
	heal_timer.connect("timeout", self, "_on_heal_timer_timeout")


func _on_heal_timer_timeout():
	Game.heal(heal_amount)	
