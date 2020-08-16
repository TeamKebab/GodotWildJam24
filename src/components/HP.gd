extends Reference


signal hp_changed(new_hp)
signal died()


var max_hp: int = 1 
var hp : int setget _set_hp


func _init(max_hp):
	self.max_hp = max_hp
	hp = max_hp


func heal(healing):
	_set_hp(hp + healing)
	

func damage(damage):
	_set_hp(hp - damage)


func _set_hp(new_hp):
	if hp == 0:
		return
	
	new_hp = clamp(new_hp, 0, max_hp)
	
	if hp == new_hp:
		return
	
	hp = new_hp
	
	emit_signal("hp_changed", hp)
	
	
	if hp == 0:
		emit_signal("died")
		



