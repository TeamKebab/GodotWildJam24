extends KinematicBody2D


const HP = preload("res://src/components/HP.gd")


enum Age {
	Teen,
	Adult,
	Elder,
}

enum State {
	Move,
	Interact,
	Attack,
}

const ADULT_AGE = int(Game.END_OF_DAY * 0.3)
const ELDER_AGE = int(Game.END_OF_DAY * 0.8)

const AGE_ANIMATIONS = {
	Age.Teen: "Teen",
	Age.Adult: "Adult",
	Age.Elder: "Elder"
}

export var acceleration: float = 200
export var max_speed: float = 100
export var max_hp: int = 2

var motion: Vector2 = Vector2.ZERO

var state = State.Move
var companion = null
var age = Age.Teen
var _baby = null

var parent = ""

onready var hp = HP.new(max_hp)

onready var detection : Area2D = $DetectionBox
onready var sprite : Sprite = $Sprite
onready var baby_sprite : Sprite = $BabySprite

onready var animationTree = $AnimationTree
onready var animationAge = animationTree.get("parameters/Age/playback")

onready var narrator = find_parent("Level").find_node("GUI")


func _ready():
	Game.connect("time_passes", self, "_on_time_passes")
	Game.connect("day_ended", self, "_on_day_ended")
	
	detection.connect("body_entered", self, "_on_detection_body_entered")
	detection.connect("body_exited", self, "_on_detection_body_exited")
	
	hp.connect("died", self, "_on_hp_died")
	
	
func _physics_process(delta):
	match state:
		State.Move:
			_move(delta)
			
			if Input.is_action_just_pressed("ui_accept"):
				_start_interaction()
				
			if Input.is_action_just_pressed("ui_attack"):
				 _attack()
				
		State.Interact:
			if Input.is_action_just_pressed("ui_accept"):
				_end_interaction(true)
				
			if Input.is_action_just_pressed("ui_cancel"):
				_end_interaction(false)
		
		State.Attack:
			pass
			

func get_info():
	return "a basic hero"
	
	
func have_child(baby):
	if _baby != null:
		return
	
	_baby = baby
	baby_sprite.show()


func has_child():
	return _baby != null


func is_in_reproductive_age():
	return age == Age.Adult or age == Age.Elder
	
	
func grow_old(time_of_day):
	match age:
		Age.Teen:
			if time_of_day >= ADULT_AGE:
				_grow_up(Age.Adult)
		Age.Adult:
			if time_of_day >= ELDER_AGE:
				_grow_up(Age.Elder)
	
	
func die():
	if _baby == null:
		Game.game_over(self)
	else:
		# todo: return monsters to starting places
		_grow_up_baby()	
	
	
func _attack():
	pass
	
		
func _move(delta):	
	var input = _get_input()
	
	if input != Vector2.ZERO:
		animationTree.set("parameters/Direction/blend_position", input)
	
	motion = motion.move_toward(input * max_speed, acceleration * delta)
		
	move_and_slide(motion)


func _get_input() -> Vector2:
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input == Vector2.ZERO:
		input = Vector2.ZERO
		
	return input.normalized()


func _start_interaction():
	var bodies = detection.get_overlapping_bodies()
	if bodies.empty():
		return
	
	var body = bodies[0]
	
	state = State.Interact
	
	if has_child():
		narrator.show("has_baby")
	elif not is_in_reproductive_age():
		narrator.show("too_young")
	elif body.is_baby_parent(self):
		narrator.show("is_parent")
	else:
		narrator.ask("want_baby")
		companion = body


func _end_interaction(answer):
	if companion != null and answer:
		have_child(companion.get_baby())
		
	narrator.close()
	companion = null
	state = State.Move
	
		
func _on_time_passes(time_of_day):
	grow_old(time_of_day)


func _on_day_ended():
	die()


func _grow_up_baby():
	parent = _baby.parent
	# todo: set other baby attributes
	
	_grow_up(Age.Teen)
	baby_sprite.hide()
	_baby = null


func _grow_up(new_age):
	age = new_age	
	animationAge.travel(AGE_ANIMATIONS[age])


func _on_detection_body_entered(body):
	body.show_help()
	

func _on_detection_body_exited(body):
	body.hide_help()


func _on_hp_died():
	die()
