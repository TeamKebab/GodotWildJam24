tool
extends StaticBody2D


signal state_changed(state)


const HP = preload("res://src/components/HP.gd")


export var on = false setget _set_on


var hp = HP.new(1)


func _ready():
	hp.connect("died", self, "_on_switch_triggered")
	set_sprite()
	

func knockback(_strength):
	pass
	
	
func set_sprite():
	if on:
		find_node("Sprite").frame = 0
	else:
		find_node("Sprite").frame = 1
	
	
func _on_switch_triggered():
	hp.hp = 1	
	_set_on(not on)


func _set_on(state):
	if state == on:
		return
		
	on = state
	
	set_sprite()
		
	emit_signal("state_changed", on)
