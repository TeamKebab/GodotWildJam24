tool
extends KinematicBody2D
class_name Monster

const HP = preload("res://src/components/HP.gd")


export var max_hp: int = 1 
export var facing_direction: Vector2 = Vector2.DOWN setget _set_facing_direction


onready var animationTree : AnimationTree = $AnimationTree

onready var hp = HP.new(max_hp)
onready var start_position = position
onready var start_direction = facing_direction


func _ready():
	hp.connect("died", self, "_die")	
	
	animationTree.set("parameters/Direction/blend_position", facing_direction)
	
	
func restart():
	position = start_position
	_set_facing_direction(start_direction)	


func _die():
	queue_free()


func _set_facing_direction(new_direction):
	facing_direction = new_direction
	
	if animationTree != null:
		animationTree.set("parameters/Direction/blend_position", facing_direction)
	
