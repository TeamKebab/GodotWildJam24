tool
extends Attack


export var damage: int = 1
export var knockback_strength: int = 150

export(String, "Normal", "Whomping", "Fire") var attack_type = "Normal"


func do_target_effect(target_hurtbox):
	if target_hurtbox == null:
		return
	
	if not overlaps_area(target_hurtbox):
		return
			
	var target = target_hurtbox.get_parent()
	
	if target == null:
		return
		
	target.hp.damage(damage, attack_type)	
	
	var parent_position = get_parent().position
	var knockback_direction = parent_position.direction_to(target.position)
	
	if knockback_direction == Vector2.ZERO:
		print("overlapping")
		
	target.knockback(knockback_direction * knockback_strength)
