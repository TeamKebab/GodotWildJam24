extends Node


const LINES = {
	"too_young": "You are a child!",
	"has_baby": "What's wrong with you? you can't go having kids with everyone! This is not Game of Thrones."
}

const SHOW_BUTTONS = ["Ok [C]"]
const ASK_BUTTONS = ["Ok [C]", "Nope [X]"]

onready var hp_label : Label = find_node("HP")
onready var time_of_day: Label = find_node("TimeOfDay")
onready var text_label : RichTextLabel = find_node("Narrator")
onready var narrator_box : Control = find_node("NarratorBox")
onready var buttons: Container = find_node("Buttons")


onready var player = find_parent("Level").find_node("Player")


func _ready():
	Game.connect("time_passes", self, "_on_time_passes")
	Game.connect("day_ended", self, "_on_day_ended")
	
	player.connect("player_hp_changed", self, "_on_player_hp_changed")
	
	hp_label.text = str(player.max_hp)
	time_of_day.text = str(Game.time_of_day)
	
func close():
	narrator_box.hide()		
	
	
func show(key):
	_ask(key, SHOW_BUTTONS)
	

func ask(key):
	_ask(key, ASK_BUTTONS)


func _ask(key, actions):
	if key in LINES:
		text_label.text = LINES[key]
	else:
		text_label.text = key
	
	for i in buttons.get_children():
		i.queue_free()
		
	for i in actions:
		var label = Label.new()
		label.text = i
		label.add_color_override("font_color", Color(0.6, 0.6, 0.6))
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
