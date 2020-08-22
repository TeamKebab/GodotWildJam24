extends StaticBody2D


const HP = preload("res://src/components/HP.gd")


export var max_hp: int = 1 

var target = null

onready var hp = HP.new(max_hp)
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var attack = $RangedAttack

func _ready():
	hp.connect("died", self, "_die")	
	hp.connect("hp_changed", self, "_on_hp_changed")
	attack.connect("attacked", self, "_on_target_attacked")


func restart():
	pass


func knockback(_strength):
	pass
	

func win():
	Game.win()
	queue_free()
	
	
func _die():
	animationState.travel("Death")
	attack.disabled = true


func _on_target_attacked(targets):
	animationState.travel("Attack")


