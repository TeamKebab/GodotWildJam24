extends StaticBody2D


const HP = preload("res://src/components/HP.gd")


export var max_hp: int = 1 

var target = null

onready var hp = HP.new(max_hp)
onready var animationPlayer = $AnimationPlayer
onready var attack = $RangedAttack

func _ready():
	hp.connect("died", self, "_die")	
	hp.connect("hp_changed", self, "_on_hp_changed")
	attack.connect("attacked", self, "_on_target_attacked")
	
	start_idle()


func restart():
	start_idle()


func knockback(_strength):
	pass
	

func start_idle():
	animationPlayer.play("Idle")


func _die():
	queue_free()
	

func _on_target_attacked(targets):
	animationPlayer.play("Attack")
	yield(animationPlayer, "animation_finished")
	start_idle()


