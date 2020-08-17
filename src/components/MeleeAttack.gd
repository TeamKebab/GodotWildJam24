tool
extends Attack


func do_target_effect(target_hurtbox):
	var target = target_hurtbox.get_parent()
	
	target.hp.damage(damage)	
	
	var parent_position = get_parent().position
	var knockback_direction = parent_position.direction_to(target.position)
	
	if knockback_direction == Vector2.ZERO:
		print("overlapping")
		
	target.knockback(knockback_direction * knockback_strength)
