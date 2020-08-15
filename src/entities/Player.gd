extends KinematicBody2D


enum Age {
	Teen,
	Adult,
	Elder
}

enum Direction {
	Right,
	Left,
	Up,
	Down
}

const ADULT_AGE = int(Game.END_OF_DAY * 0.3)
const ELDER_AGE = int(Game.END_OF_DAY * 0.8)


export var acceleration: float = 100
export var friction: float = 0.5
export var max_speed: float = 100


var motion: Vector2 = Vector2.ZERO
var current_direction = Direction.Right

var age = Age.Teen
var _baby = null


onready var sprite : Sprite = $Sprite


func _ready():
	Game.connect("time_passes", self, "_on_time_passes")
	Game.connect("day_ended", self, "_on_day_ended")
	
	
func _physics_process(delta):
	_move(delta)
	

func get_info():
	return "a basic hero"
	
	
func have_child(baby):
	if _baby != null:
		return
	
	_baby = baby
	
	
func can_have_child():
	return _baby == null and (age == Age.Adult or age == Age.Elder)


func grow_old(time_of_day):
	match age:
		Age.Teen:
			if time_of_day >= ADULT_AGE:
				age = Age.Adult
				_update_sprite_frame()
		Age.Adult:
			if time_of_day >= ELDER_AGE:
				age = Age.Elder
				_update_sprite_frame()
	
	
func die():
	if _baby == null:
		Game.game_over(self)
	else:
		_grow_up_baby()
	
	
func _move(delta):	
	var input = _get_input()
		
	if input.x == 0:
		motion.x = lerp(motion.x, 0, friction)
	
	if input.y == 0:
		motion.y = lerp(motion.y, 0, friction)		
	
	if input != Vector2.ZERO:
		motion = (motion + input * acceleration * delta).clamped(max_speed)
		# todo set current direction
		
	move_and_slide(motion)


func _get_input() -> Vector2:
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input == Vector2.ZERO:
		input = Vector2.ZERO
		
	return input.normalized()


func _on_time_passes(time_of_day):
	grow_old(time_of_day)


func _on_day_ended():
	die()


func _grow_up_baby():
	# todo: set baby attributes
	age = Age.Teen
	_baby = null


func _update_sprite_frame():
	sprite.frame = current_direction * 4 + age
