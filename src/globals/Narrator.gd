extends Node


const Interaction = preload("res://src/components/Interaction.tscn")

const LINES = {
	"game_start": "Many generations before our time, a hero fallen from grace reached these shores in search of the promised land. What was the promised land, they knew not, but it sounded pretty cool and they were bored back at home. But they knew they did not have much time left, so they would have to pass on this quest onto the next generation...",
	"first_shrine": "Inside these walls, the Hero found love... In the form of a beautiful orc! Love is blind <3 And sometimes, it smells weird too <3 <3 <3",
	"first_multiple_shrine": "IT'S MATING SEASON! The hero chose a partner carefully, thinking on what was to come on their journey and who would make better pancakes in the morning. Breakfast is the most important meal of the day. Stay hydrated.",
	"first_baby": "Love has given its fruits! And a baby too! Now the hero's quest will continue even when life abandons them...",
	
	"new_hero": "And the hero's days came to an end... Now the child becomes the hero, and carries the burden their progenitor. Figuratively speaking, we aren't carrying corpses around, we aren't that psycho yet. But let's pick the sword.",
	"game_end": "And that's how I met your mother",
	
	"too_young": "You are a child!",
	"has_baby": "What's wrong with you? you can't go having kids with everyone! This is not Game of Thrones.",
	"is_parent": "Hey, that's your parent; this is high fantasy, but let's keep it incest-free ok? This is not Game of Thrones.",
	
	"want_baby_orc": "The Hero could feel the strength of the orcs, and their smell... Do you want to have a baby?",
	"want_baby_elf": "The hero could feel the silent and boring resolve of the elves... Do you want to have a baby?",
	"want_baby_gnome": "The hero could feel the crazy and explosive love of the gnomes... Do you want to have a baby?",
	
	
	"got_baby_orc": "It's green and smells like wet potatoes... Gotta love it!",
	"got_baby_elf": "Too cute to be my kid... Why is it aiming that bow at me?",
	"got_baby_gnome": "DA BOMB! It's so small I always think I sat on it.",
	
	"ask_skip_to_swamp": "The hero paused before the darkly lit passage into the unknown. This could be a shortcut, but it could also lead to untold dangers. Would they be brave enough to continue?",
}

const TOOLTIPS = {
	"orc": "[b][color=#897657]Orc Baby[/color][/b]\nGiant Club: slow, but hurts a lot\nResistant: higher HP\nCan crush fences",
	"elf": "[b][color=#897657]Elf Baby[/color][/b]\nBow: kill from afar!\nWeakling: reduced HP\nCan hit switches with arrows",
	"gnome": "[b][color=#897657]Gnome Baby[/color][/b]\nBombs: kill everybody in range!\nCan explode rocks",
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
