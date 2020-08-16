extends KinematicBody2D


const HP = preload("res://src/components/HP.gd")


export var max_hp: int = 1 


onready var hp = HP.new(max_hp)


func _ready():
	hp.connect("died", self, "_die")	


func _die():
	queue_free()



