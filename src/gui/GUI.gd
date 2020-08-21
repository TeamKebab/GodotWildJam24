extends Node


onready var hp_label : Label = find_node("HP")
onready var hearts = find_node("Hearts")
onready var time_of_day: Label = find_node("TimeOfDay")

onready var text_label : RichTextLabel = find_node("Narrator")
onready var narrator_box : Control = find_node("NarratorBox")
onready var buttons: Container = find_node("Buttons")


func _ready():
	Game.connect("time_passes", self, "_on_time_passes")
	Game.connect("day_ended", self, "_on_day_ended")
	
	Game.connect("player_hp_changed", self, "_on_player_hp_changed")
	
	Narrator.gui = self
	
	hearts.value = Game.hp
	hp_label.text = str(Game.hp)
	
	time_of_day.text = str(Game.time_of_day)
	
	
func close_dialog():
	narrator_box.hide()		


func show_dialog(text, actions):
	text_label.text = text
	
	for i in buttons.get_children():
		i.queue_free()
		
	for i in actions:
		var label = Label.new()
		label.text = i
		buttons.add_child(label)
	
	# resize for text (WTF)
	narrator_box.show()
	narrator_box.hide()

	narrator_box.show()		


func _on_time_passes(time):
	time_of_day.text = str(time)


func _on_day_ended():
	time_of_day.text = str(0)


func _on_player_hp_changed(hp):
	hp_label.text = str(hp)
	hearts.value = hp
