extends StaticBody2D


const HP = preload("res://src/components/HP.gd")


export(Array, String, "Normal", "Whomping", "Fire") var immune_to = [] setget _set_immune_to
export var max_hp: int = 1 setget _set_max_hp


var hp = HP.new(max_hp)


func _ready():
	hp.connect("died", self, "destroy")
	hp.immune_to = immune_to
	hp.max_hp = max_hp


func knockback(strength):
	pass

	
func destroy():
	queue_free()


func _set_max_hp(new_max_hp):
	max_hp = new_max_hp
	hp.max_hp = max_hp
	
	
func _set_immune_to(new_value):
	immune_to = new_value
	
	if hp != null:
		hp.immune_to = immune_to
