tool
extends "res://src/components/overlap/DetectionBox.gd"
class_name Attack

signal attacked(targets)


export var single_hit: bool = true
export var area_attack: bool = false
export var attack_cooldown: float = 1

var attacked_targets = []


onready var cooldown_timer : Timer = $Cooldown


func _ready():
	connect("area_entered", self, "_on_area_entered")
	connect("attacked", self, "_on_attack_triggered")
	
	cooldown_timer.connect("timeout", self, "_on_cooldown_timeout")
		

func is_valid_target(target):
	return target.get("hp") != null  and target.has_method("knockback")


func do_effect():
	for target in attacked_targets:
		do_target_effect(target)
	attacked_targets = []


func do_target_effect(target_hurtbox):
	pass
	

func _trigger_attack():
	var areas = get_overlapping_areas()
	
	if areas.empty():
		return
		
	attacked_targets = []
	
	for area in areas:
		var target = area.get_parent()
		if is_valid_target(target):
			attacked_targets.append(area)
			
			if not area_attack:
				break
	
	if not attacked_targets.empty():
		emit_signal("attacked", attacked_targets)


func _on_area_entered(_area):
	_trigger_attack()


func _on_cooldown_timeout():
	disabled = false
	

func _on_attack_triggered(_targets):
	disabled = true
	
	if not single_hit:
		cooldown_timer.start(attack_cooldown)		

