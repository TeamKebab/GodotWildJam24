extends Node


const LINES = {
	"too_young": "You are a child!",
	"has_baby": "What's wrong with you? you can't go having kids with everyone! This is not Game of Thrones.",
	"want_baby": "aaaaaaa",
	"want_baby_orc": "The Hero could feel the strength of the orcs, and their smell... Do you want to have a baby?",
}

const TOOLTIPS = {
	"orc": "[b][color=#897657]Orc Baby[/color][/b]\nGiant Club: slow, but hurts a lot\nResistant: higher HP\nCan crush fences",
	"elf": "[b][color=#897657]Elf Baby[/color][/b]\nBow: kill from afar!\nWeakling: reduced HP\nCan hit switches with arrows",
}


const SHOW_BUTTONS = ["Ok [C]"]
const ASK_BUTTONS = ["Ok [C]", "Nope [X]"]


var gui : Node

	
func show(key):
	Game.pause_day()
	gui.show_dialog(LINES.get(key, key), SHOW_BUTTONS)
	

func ask(key):
	Game.pause_day()
	gui.show_dialog(LINES.get(key, key), ASK_BUTTONS)


func ask_with_tooltip(key, tooltip_key):
	Game.pause_day()
	gui.show_dialog(LINES.get(key,key), ASK_BUTTONS, TOOLTIPS.get(tooltip_key, null))
	
	
func close():
	Game.resume_day()
	gui.close_dialog()
