extends StaticBody2D


export var id: String = "baby mama"
export var want_baby_text: String = "want_baby"
export var race: String = "human"

var can_have_baby = false

onready var interaction = $Interaction

func _ready():
	interaction.connect("interaction_started", self, "_on_interaction_started")
	interaction.connect("interaction_ended", self, "_on_interaction_ended")
	
	
func start_interaction(player):
	can_have_baby = false
	
	if player.has_child():
		Narrator.show("has_baby")
	elif not player.is_in_reproductive_age():
		Narrator.show("too_young")
	elif is_baby_parent(player):
		Narrator.show("is_parent")
	else:
		Narrator.ask_with_tooltip(want_baby_text, race)
		can_have_baby = true


func end_interaction(player, answer):
	if can_have_baby and answer:
		player.have_child(get_baby())
		
	Narrator.close()	


func is_baby_parent(baby):
	return baby.parent == id
 

func get_baby():
	return {
		"parent": id,
		"race": race
	}


func _on_interaction_started(player):
	start_interaction(player)
	

func _on_interaction_ended(player, answer):
	end_interaction(player, answer)
