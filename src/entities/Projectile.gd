tool
extends "res://src/components/overlap/DetectionBox.gd"


export var damage: int = 1
export var knockback_strength: int = 150
export var speed: int = 100

export var destroy_on_connect : bool = true
export var distance: float = 100

export(String, "Normal", "Whomping", "Fire") var damage_type = "Normal"
 

var start_position : Vector2
var motion : Vector2


func _ready():
	connect("area_entered", self, "_on_area_entered")
	

func _physics_process(delta):
	if motion == Vector2.ZERO:
		return
	
	move(delta)
	
	if position.distance_squared_to(start_position) > pow(distance, 2):
		destroy()
		
		
func move(delta):
	position += motion * delta
	

func shot(target_hurtbox, start_position):
	self.start_position = start_position
	
	var target_collision_layer = target_hurtbox.get_collision_layer()
	var target_position = target_hurtbox.get_parent().position
	
	var direction = start_position.direction_to(target_position)
	
	collision_mask &= target_collision_layer
	position = start_position
	rotation = direction.angle()
	motion = direction * speed
	
	
func destroy():
	queue_free()
	
	
func is_valid_target(target):
	return target.get("hp") != null and target.has_method("knockback")


func do_target_effect(target):
	target.hp.damage(damage, damage_type)			
	target.knockback(motion.normalized() * knockback_strength)


func hit(target):
	if is_valid_target(target):
		do_target_effect(target)
	
	if destroy_on_connect:
		destroy()
		
			
func _on_area_entered(area):
	hit(area.get_parent())
