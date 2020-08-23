extends "res://src/maps/Level.gd"


onready var endgame = find_node("EndGame").find_node("Interaction")
onready var win_sound = $WinSound

func _ready():
	for entity in entities_container.get_children():
		if entity is Dragon:
			entity.connect("boss_defeated", self, "_on_dragon_defeated")
	
	endgame.connect("interaction_started", self, "_on_interaction_started")
	endgame.connect("interaction_ended", self, "_on_interaction_ended")


func _on_dragon_defeated():
	print("dragon defeated!")
	set_map("Walls", Rect2(6,-31,2,3), -1)
	

func _on_interaction_started(_player):
	win_sound.play()
	Narrator.show("game_end")
	
	
func _on_interaction_ended(_player, _answer):
	Game.win()
