tool
extends Area2D


signal attacked(targets)


export(Shape2D) var shape: Shape2D setget _set_shape

export var damage: int = 1
export var single_hit: bool = true
export var area_attack: bool = false
export var attack_cooldown: float = 3

onready var cooldown_timer : Timer = $Cooldown


func _ready():
	connect("area_entered", self, "_on_area_entered")
	connect("attacked", self, "_on_attack_triggered")
	
	if not single_hit:
		cooldown_timer.connect("timeout", self, "_on_cooldown_timeout")
		

func is_valid_target(target):
	return target.hp != null


func do_effect(target):
	target.hp.damage(damage)

		
func _trigger_attack():
	var areas = get_overlapping_areas()
	
	if areas.empty():
		return
		
	var attacked_targets = []
	
	for area in areas:
		var target = area.get_parent()
		if is_valid_target(target):
			do_effect(target)
			attacked_targets.append(target)
			
			if not area_attack:
				break
	
	if not attacked_targets.empty():
		emit_signal("attacked", attacked_targets)


func _on_area_entered(area):
	if cooldown_timer.is_stopped():
		_trigger_attack()


func _on_cooldown_timeout():
	_trigger_attack()
	

func _on_attack_triggered(targets):
	cooldown_timer.start(attack_cooldown)		


func _set_shape(new_shape):
	shape = new_shape
	$CollisionShape2D.set_shape(shape)
