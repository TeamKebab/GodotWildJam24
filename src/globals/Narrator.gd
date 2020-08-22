extends Node


const Interaction = preload("res://src/components/Interaction.tscn")

const LINES = {
	"first_shrine": "Inside these walls, the Hero found love... In the form of a beautiful orc! Love is blind <3 And sometimes, it smells weird too <3 <3 <3",
	"first_multiple_shrine": "IT'S MATING SEASON! The hero chose a partner carefully, thinking on what was to come on their journey and who would make better pancakes in the morning. Breakfast is the most important meal of the day. Stay hydrated.",
	
	"too_young": "You are a child!",
	"has_baby": "What's wrong with you? you can't go having kids with everyone! This is not Game of Thrones.",
	"is_parent": "Hey, that's your parent; this is high fantasy, but let's keep it incest-free ok? This is not Game of Thrones.",
	
	"want_baby_orc": "The Hero could feel the strength of the orcs, and their smell... Do you want to have a baby?",
	
	"first_baby": "Love has given its fruits! And a baby too! Now the hero's quest will continue even when life abandons them...",
	
	"got_baby_orc": "It's green and smells like wet potatoes... Gotta love it!",
	"got_baby_elf": "Too cute to be my kid... Why is it aiming that bow at me?",
}

const TOOLTIPS = {
	"orc": "[b][color=#897657]Orc Baby[/color][/b]\nGiant Club: slow, but hurts a lot\nResistant: higher HP\nCan crush fences",
	"elf": "[b][color=#897657]Elf Baby[/color][/b]\nBow: kill from afar!\nWeakling: reduced HP\nCan hit switches with arrows",
}


const SHOW_BUTTONS = ["Ok [C]"]
const ASK_BUTTONS = ["Ok [C]", "Nope [X]"]


var gui : Node
var interaction

func _ready():
	interaction = Interaction.instance()
	add_child(interaction)
	
	
func show(key):
	Game.pause_day()
	gui.show_dialog(LINES.get(key, key), SHOW_BUTTONS)
	

func show_with_interaction(player, key):
	show(key)
	player.interact(interaction)
	yield(interaction, "interaction_ended")
	close()
	
	
func ask(key):
	Game.pause_day()
	gui.show_dialog(LINES.get(key, key), ASK_BUTTONS)


func ask_with_tooltip(key, tooltip_key):
	Game.pause_day()
	gui.show_dialog(LINES.get(key,key), ASK_BUTTONS, TOOLTIPS.get(tooltip_key, null))
	
	
func close():
	Game.resume_day()
	gui.close_dialog()
