tool
extends KinematicBody2D
class_name Monster

const HP = preload("res://src/components/HP.gd")


export var max_hp: int = 1 
export var acceleration: int = 50
export var facing_direction: Vector2 = Vector2.DOWN setget _set_facing_direction

export var min_turn_around_time : float = 0.5
export var max_turn_around_time : float = 2
export var speed : int = 50


var attacks = []
var target = null
var motion : Vector2 = Vector2.ZERO


onready var animationTree : AnimationTree = $AnimationTree

onready var hp = HP.new(max_hp)
onready var start_position = position
onready var start_direction = facing_direction

onready var turn_around_timer = $TurnAroundTimer
onready var detection = $DetectionBox
onready var outer_detection = $OuterDetectionBox

onready var animationAction = $AnimationTree.get("parameters/Action/playback")
onready var navigation = find_parent("Level").find_node("Navigation2D")


func _ready():
	turn_around_timer.connect("timeout", self, "_on_TurnAroundTimer_timeout")
	
	detection.connect("area_entered", self, "_on_detection_area_entered")
	outer_detection.connect("area_exited", self, "_on_outer_detection_area_exited")
	
	hp.connect("died", self, "_die")	
	hp.connect("hp_changed", self, "_on_hp_changed")
	
	for child in get_children():
		if child is Attack:
			attacks.append(child)
			child.connect("attacked", self, "_on_target_attacked")
	
	animationTree.set("parameters/Direction/blend_position", facing_direction)
	
	start_idle()
	

func _physics_process(delta):
	if Engine.editor_hint:
		return
	
	if motion == Vector2.ZERO:
		match animationAction.get_current_node():
			"Idle":
				pass
			"Attack":
				pass
			"Pursue":
				pursue(delta)
			"Return":
				return_to_start(delta)
	else:
		move(delta)
		
	
func restart():
	position = start_position
	_set_facing_direction(start_direction)	
	target = null
	
	start_idle()


func knockback(strength):
	motion = motion + strength
	
	
func move(delta):
	if motion == Vector2.ZERO:
		return

	motion = motion.move_toward(Vector2.ZERO, acceleration * delta)
	
	motion = move_and_slide(motion)


func pursue(delta):
	if target == null:
		start_returning()
		return
	
	if not can_attack_target():
		_move_to_point(target.get_parent().position, delta)
	

func can_attack_target():
	for attack in attacks:
		if attack.overlaps_area(target):
			return true
			
	return false
	
	
func return_to_start(delta):
	if position == start_position:
		start_idle()
		return
	
	_move_to_point(start_position, delta)
	
		
func turn_around():
	var random_direction = randi() % 2
	
	if random_direction == 0:
		_set_facing_direction(facing_direction.rotated(PI/2))
	else:
		_set_facing_direction(facing_direction.rotated(-PI/2))


func start_idle():
	if Engine.editor_hint:
		return
		
	turn_around_timer.start(rand_range(min_turn_around_time, max_turn_around_time))
	
	_set_facing_direction(start_direction)
	animationAction.travel("Idle")


func start_pursuing():
	animationAction.travel("Pursue")
	

func start_returning():
	target = null
	animationAction.travel("Return")


func _die():
	queue_free()


func _set_facing_direction(new_direction):
	if new_direction == Vector2.ZERO:
		return
		
	facing_direction = new_direction
	
	if animationTree != null:
		animationTree.set("parameters/Direction/blend_position", facing_direction)


func _move_to_point(point, delta):
	var move_distance = speed * delta
	
	var new_direction = Vector2.ZERO
	
	var path = navigation.get_simple_path(position, point)
	
	for step in path:
		new_direction = position.direction_to(step)
		var distance_to_step = position.distance_to(step)
		
		if distance_to_step >= move_distance:
			position = position.linear_interpolate(step, move_distance / distance_to_step)
			break
		else: 
			position = step
			move_distance -= distance_to_step
	
	if new_direction != Vector2.ZERO:
		_set_facing_direction(new_direction)

			
func _on_TurnAroundTimer_timeout():
	turn_around()
	turn_around_timer.start(rand_range(min_turn_around_time, max_turn_around_time))	


func _on_detection_area_entered(area):
	target = area
	start_pursuing()
	

func _on_outer_detection_area_exited(area):
	if area == target:
		start_returning()


func _on_target_attacked(_targets):
	animationAction.travel("Attack")
	
	
func _on_hp_changed(new_hp):
	$Label.text = str(new_hp)

