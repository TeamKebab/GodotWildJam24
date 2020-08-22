tool
extends "res://src/components/overlap/DetectionBox.gd"


signal interaction_started(player)
signal interaction_ended(player, answer)


export var help: String = "Press [C] to talk"


onready var help_label: Label = $Label


func _ready():
	help_label.text = help
	
	if Engine.editor_hint:
		return
	
	help_label.hide()
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	

func player_detected(_player):
	help_label.show()
	

func player_left(_player):
	help_label.hide()
	

func show_narrator(player, text):
	player.interact(self)
	Narrator.show(text)
	
	yield(self, "interaction_ended")
	
	Narrator.close()
	
	
func start_interaction(player):
	emit_signal("interaction_started", player)


func end_interaction(player, answer):
	emit_signal("interaction_ended", player, answer)


func _on_area_entered(area):
	player_detected(area.get_parent())
	

func _on_area_exited(area):
	player_left(area.get_parent())
