tool
extends KinematicBody2D


const HP = preload("res://src/components/HP.gd")


export var max_hp: int = 1 
export var facing_direction: Vector2 = Vector2.DOWN setget _set_facing_direction

var motion = Vector2.ZERO


onready var animationTree : AnimationTree = $AnimationTree

onready var hp = HP.new(max_hp)
onready var start_position = position


func _ready():
	hp.connect("died", self, "_die")	
	
	animationTree.set("parameters/blend_position", facing_direction)

func _physics_process(delta):
		
	motion = move_and_slide(motion)
	
	
func restart():
	position = start_position


func _die():
	queue_free()


func _set_facing_direction(new_direction):
	facing_direction = new_direction
	
	if $AnimationTree != null:
		$AnimationTree.set("parameters/blend_position", facing_direction)
	
