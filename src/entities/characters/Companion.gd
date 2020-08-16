extends StaticBody2D


export var id: String = "baby mama"
export var help: String = "Press [C] to talk"

onready var help_label: Label = $Label


func _ready():
	help_label.text = help
	help_label.hide()


func show_help():
	help_label.show()
	

func hide_help():
	help_label.hide()
	
	
func is_baby_parent(baby):
	return baby.parent == id
 

func get_baby():
	return {
		"parent": id
	}
