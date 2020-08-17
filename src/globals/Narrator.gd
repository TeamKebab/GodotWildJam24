extends Node


const LINES = {
	"too_young": "You are a child!",
	"has_baby": "What's wrong with you? you can't go having kids with everyone! This is not Game of Thrones."
}

const SHOW_BUTTONS = ["Ok [C]"]
const ASK_BUTTONS = ["Ok [C]", "Nope [X]"]


var gui : Node

	
func show(key):
	gui.show_dialog(LINES.get(key, key), SHOW_BUTTONS)
	

func ask(key):
	gui.show_dialog(LINES.get(key, key), ASK_BUTTONS)


func close():
	gui.close_dialog()
