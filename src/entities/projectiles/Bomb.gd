extends "res://src/entities/projectiles/Projectile.gd"


onready var sound = $AudioStreamPlayer


func hit(_target):
	if motion != Vector2.ZERO:
		destroy()


func shot(target_hurtbox, start_position):
	.shot(target_hurtbox, start_position)
	
	rotation = 0
	
	$AreaOfEffect.collision_mask = target_hurtbox.get_collision_layer()

	
func do_target_effect(target):
	target.hp.damage(damage, damage_type)			
	target.knockback(position.direction_to(target.position) * knockback_strength)	


func destroy():
	motion = Vector2.ZERO
	
	$AnimationPlayer.play("Start")
	
	yield($AnimationPlayer, "animation_finished")
	
	var targets = $AreaOfEffect.get_overlapping_areas()
	
	for target_area in targets:
		var target = target_area.get_parent()
		
		if is_valid_target(target):
			do_target_effect(target)
	
	sound.play()
	$AnimationPlayer.play("Boom")
	
	yield($AnimationPlayer, "animation_finished")
	
	queue_free()
