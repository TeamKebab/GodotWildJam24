tool
extends KinematicBody2D
class_name Monster

const HP = preload("res://src/components/HP.gd")


export var max_hp: int = 1 
export var acceleration: int = 50
export var facing_direction: Vector2 = Vector2.DOWN setget _set_facing_direction


var motion : Vector2 = Vector2.ZERO


onready var animationTree : AnimationTree = $AnimationTree

onready var hp = HP.new(max_hp)
onready var start_position = position
onready var start_direction = facing_direction


func _ready():
	hp.connect("died", self, "_die")	
	hp.connect("hp_changed", self, "_on_hp_changed")
	
	animationTree.set("parameters/Direction/blend_position", facing_direction)
	

func _physics_process(delta):
	move(delta)
	
	
func move(delta):
	if motion == Vector2.ZERO:
		return

	motion = motion.move_toward(Vector2.ZERO, acceleration * delta)
	
	motion = move_and_slide(motion)
	
		
func restart():
	position = start_position
	_set_facing_direction(start_direction)	


func knockback(strength):
	motion = motion + strength
	
	
func _die():
	queue_free()


func _set_facing_direction(new_direction):
	facing_direction = new_direction
	
	if animationTree != null:
		animationTree.set("parameters/Direction/blend_position", facing_direction)
	

func _on_hp_changed(new_hp):
	$Label.text = str(new_hp)
