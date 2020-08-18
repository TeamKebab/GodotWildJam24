extends StaticBody2D


const HP = preload("res://src/components/HP.gd")


export(Array, String) var vulnerable_to = [] setget _set_vulnerable_to
export var max_hp: int = 1 


onready var hp = HP.new(max_hp)


func _ready():
	hp.connect("died", self, "destroy")
	hp.vulnerable_to = vulnerable_to

	
func destroy():
	queue_free()


func _set_vulnerable_to(new_value):
	vulnerable_to = new_value
	
	if hp != null:
		hp.vulnerable_to = vulnerable_to
