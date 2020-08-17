tool
extends Attack

export(PackedScene) var Projectile


func do_target_effect(target_hurtbox):
	var parent = get_parent()
	var container = parent.get_parent()
	
	var projectile = Projectile.instance()
	container.add_child(projectile)
	projectile.shot(target_hurtbox, parent.position)
	
