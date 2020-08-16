extends KinematicBody2D


const HP = preload("res://src/components/HP.gd")


export var max_hp: int = 1 


var motion = Vector2.ZERO


onready var hp = HP.new(max_hp)
onready var start_position = position


func _ready():
	hp.connect("died", self, "_die")	


func _physics_process(delta):
	motion = move_and_slide(motion)
	
	
func restart():
	position = start_position


func _die():
	queue_free()

