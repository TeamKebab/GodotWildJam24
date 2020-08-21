extends KinematicBody2D


const HP = preload("res://src/components/HP.gd")


export var max_hp: int = 1 
export var acceleration: int = 50
export var facing_direction: Vector2 = Vector2.DOWN setget _set_facing_direction


export var min_teleport_time : float = 3
export var max_teleport_time : float = 10
export var teleport_range : int = 200


var motion : Vector2 = Vector2.ZERO

var teleport_loading = true

onready var animationTree : AnimationTree = $AnimationTree

onready var hp = HP.new(max_hp)
onready var start_position = position
onready var start_direction = facing_direction

onready var teleport_timer = $TeleportTimer
onready var teleport_area = $TeleportArea
onready var attack = $RangedAttack

onready var animationAction = $AnimationTree.get("parameters/Action/playback")
onready var navigation = find_parent("Level").find_node("Navigation2D")


func _ready():
	teleport_timer.connect("timeout", self, "_on_TeleportTimer_timeout")
	
	hp.connect("died", self, "_die")
	
	attack.connect("attacked", self, "_on_target_attacked")
	
	animationTree.set("parameters/Direction/blend_position", facing_direction)
	
	start_idle()
	
	
func _physics_process(delta):	
	if motion == Vector2.ZERO:
		match animationAction.get_current_node():
			"Idle":
				if teleport_loading:
					teleport_loading = false
				elif teleport_area.position != Vector2.ZERO:
					teleport()
			"Attack":
				pass
			"Pursue":
				pursue(delta)
	else:
		move(delta)


func restart():
	position = start_position
	_set_facing_direction(start_direction)	
	
	start_idle()

	
func knockback(strength):
	motion = motion + strength

	
func move(delta):
	if motion == Vector2.ZERO:
		return

	motion = motion.move_toward(Vector2.ZERO, acceleration * delta)
	
	motion = move_and_slide(motion)

	
func start_pursuing():
	animationAction.travel("Pursue")
	teleport_timer.stop()	
	

func pursue(_delta):
	var targets = attack.get_overlapping_areas()
	if targets.empty():
		start_idle()
	

func start_idle():
	teleport_timer.stop()
	start_teleport_timer()
	
	_set_facing_direction(start_direction)
	animationAction.travel("Idle")


func start_teleport():
	animationAction.travel("Idle")
	find_teleport_position()
	

func start_teleport_timer():
	var time = Game.rng.randf_range(min_teleport_time, max_teleport_time)
	teleport_timer.start(time)


func find_teleport_position():
	var dist = Game.rng.randf_range(0, teleport_range)
	var angle = Game.rng.randf_range(0, 2 * PI)
	
	teleport_area.position = Vector2(dist,0).rotated(angle)
	teleport_loading = true
	
		
func teleport():
	var overlapping_areas = teleport_area.get_overlapping_areas()
	
	if not overlapping_areas.empty():
		find_teleport_position()
		return
		
	var overlapping_bodies = teleport_area.get_overlapping_bodies()
	
	if not overlapping_bodies.empty():
		find_teleport_position()
		return
	
	var dest = position + teleport_area.position
	var navigation_point = navigation.get_closest_point(dest)
	
	if dest != navigation_point:
		find_teleport_position()
		return
	
	position = dest
	teleport_area.position = Vector2.ZERO
		
	start_teleport_timer()

	
		
func _die():
	queue_free()

	
func _set_facing_direction(new_direction):
	if new_direction == Vector2.ZERO:
		return
		
	facing_direction = new_direction
	
	if animationTree != null:
		animationTree.set("parameters/Direction/blend_position", facing_direction)


func _on_TeleportTimer_timeout():
	animationAction.travel("Teleport")


func _on_target_attacked(targets):
	if targets.empty():
		return
	
	var player_hurtbox = targets[0]
	
	if player_hurtbox == null:
		return
	
	var player_position = player_hurtbox.get_parent().position
	
	_set_facing_direction(position.direction_to(player_position))
	
	animationAction.travel("Attack")
