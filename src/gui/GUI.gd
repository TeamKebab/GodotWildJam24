extends Node


const LINES = {
	"too_young": "You are a child!",
	"has_baby": "What's wrong with you? you can't go having kids with everyone! This is not Game of Thrones."
}

const SHOW_BUTTONS = ["Ok [ENTER]"]
const ASK_BUTTONS = ["Ok [ENTER]", "Nope [ESC]"]


onready var text_label : RichTextLabel = find_node("Narrator")
onready var narrator_box : Control = find_node("NarratorBox")
onready var buttons: Container = find_node("Buttons")

	
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

