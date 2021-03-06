tool
extends Area2D

signal disabled_changed(value)


export(Shape2D) var shape: Shape2D setget _set_shape
export var disabled: bool setget _set_disabled


func _set_shape(new_shape):
	shape = new_shape
	$CollisionShape2D.set_shape(shape)


func _set_disabled(new_disabled):
	if disabled == new_disabled:
		return
		
	$CollisionShape2D.set_deferred("disabled", new_disabled)
	
	disabled = new_disabled
	emit_signal("disabled_changed", disabled)
