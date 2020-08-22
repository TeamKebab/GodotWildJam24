extends "res://src/maps/Level.gd"


export var heal_amount = 1

onready var heal_timer: Timer = $HealTimer

func _ready():
	heal_timer.connect("timeout", self, "_on_heal_timer_timeout")
		
	if Game.first_multiple_companion_shrine:
		if has_multiple_companions():
			Game.first_multiple_companion_shrine = false
			Narrator.show_with_interaction(player, "first_multiple_shrine")


func has_multiple_companions():
	var companion_count = 0
	for item in find_node("YSort").get_children():
		if item is Companion:
			companion_count += 1
	
	return companion_count > 1
	
	
func _on_heal_timer_timeout():
	Game.heal(heal_amount)	
