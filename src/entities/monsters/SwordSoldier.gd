tool
extends Monster


export var min_turn_around_time : float = 0.5
export var max_turn_around_time : float = 2
export var speed : int = 50

var target = null


onready var turn_around_timer = $TurnAroundTimer
onready var detection = $DetectionBox
onready var outer_detection = $OuterDetectionBox

onready var animationAction = $AnimationTree.get("parameters/Action/playback")
onready var navigation = find_parent("Level").find_node("Navigation2D")


func _ready():
	turn_around_timer.connect("timeout", self, "_on_TurnAroundTimer_timeout")
	detection.connect("area_entered", self, "_on_detection_area_entered")
	outer_detection.connect("area_exited", self, "_on_outer_detection_area_exited")
	
	start_idle()


func _physics_process(delta):
	if Engine.editor_hint:
		return
	
	match animationAction.get_current_node():
		"Idle":
			pass
		"Attack":
			pass
		"Pursue":
			pursue(delta)
		"Return":
			return_to_start(delta)

	
func restart():
	target = null
	start_idle()


func pursue(delta):
	if target == null:
		start_returning()
		return
	
	_move_to_point(target.position, delta)
	

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


func start_pursuing(player):
	target = player
	animationAction.travel("Pursue")
	

func start_returning():
	target = null
	animationAction.travel("Return")
	

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
	start_pursuing(area.get_parent())
	

func _on_outer_detection_area_exited(area):
	var body = area.get_parent()
	
	if body == target:
		start_returning()
