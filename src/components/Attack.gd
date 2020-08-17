tool
extends "res://src/components/overlap/DetectionBox.gd"


signal attacked(targets)


export var damage: int = 1
export var knockback_strength: int = 150
export var single_hit: bool = true
export var area_attack: bool = false
export var attack_cooldown: float = 1


var attacked_targets = []


onready var cooldown_timer : Timer = $Cooldown


func _ready():
	connect("area_entered", self, "_on_area_entered")
	connect("attacked", self, "_on_attack_triggered")
	
	if not single_hit:
		cooldown_timer.connect("timeout", self, "_on_cooldown_timeout")
		

func is_valid_target(target):
	return target.hp != null and target.has_method("knockback")


func do_effect():
	for target in attacked_targets:
		do_target_effect(target)
	attacked_targets = []


func do_target_effect(target):
	target.hp.damage(damage)	
	
	var parent_position = get_parent().position
	var knockback_direction = parent_position.direction_to(target.position)
	
	if knockback_direction == Vector2.ZERO:
		print("overlapping")
		
	target.knockback(knockback_direction * knockback_strength)
	
	
func _trigger_attack():
	var areas = get_overlapping_areas()
	
	if areas.empty():
		return
		
	attacked_targets = []
	
	for area in areas:
		var target = area.get_parent()
		if is_valid_target(target):
			attacked_targets.append(target)
			
			if not area_attack:
				break
	
	if not attacked_targets.empty():
		emit_signal("attacked", attacked_targets)


func _on_area_entered(_area):
	if cooldown_timer.is_stopped():
		_trigger_attack()


func _on_cooldown_timeout():
	_trigger_attack()
	

func _on_attack_triggered(_targets):
	if not single_hit:
		cooldown_timer.start(attack_cooldown)		

