extends StaticBody2D
class_name Dragon


signal boss_defeated()


const HP = preload("res://src/components/HP.gd")


export var max_hp: int = 1 

var target = null

onready var hit_sound = $HitSound
onready var hp = HP.new(max_hp)
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var attack = $RangedAttack

func _ready():
	hp.connect("died", self, "_die")	
	hp.connect("hp_changed", self, "_on_hp_changed")
	attack.connect("attacked", self, "_on_target_attacked")


func restart():
	animationState.travel("Idle")


func knockback(_strength):
	pass
	

func win():
	emit_signal("boss_defeated")
	
	
func end_attack():
	if hp.hp > 0:
		animationState.travel("Idle")
	else:
		animationState.travel("Death")
		attack.disabled = true
		
		
func _on_hp_changed(new_hp):
	print("Dragon HP: " + str(new_hp))
	hit_sound.play()

	
func _die():
	animationState.travel("Death")
	attack.disabled = true


func _on_target_attacked(targets):
	animationState.travel("Attack")


