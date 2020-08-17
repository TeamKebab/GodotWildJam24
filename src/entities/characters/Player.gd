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



const AGE_ANIMATIONS = {
	Age.Teen: "Teen",
	Age.Adult: "Adult",
	Age.Elder: "Elder"
}

export var acceleration: float = 200
export var max_speed: float = 100

var motion: Vector2 = Vector2.ZERO

var interacting_item = null

var state = State.Move
var age = Age.Teen

var hp = HP.new(Game.max_hp)
var _baby = null
var parent = ""

onready var detection : Area2D = $DetectionBox
onready var baby_sprite : Sprite = $BabySprite

onready var animationTree = $AnimationTree
onready var animationAge = animationTree.get("parameters/Age/playback")
onready var animationState = animationTree.get("parameters/Action/playback")


func _ready():
	Game.connect("time_passes", self, "_on_time_passes")
	Game.connect("day_ended", self, "_on_day_ended")
	
	detection.connect("body_entered", self, "_on_detection_body_entered")
	detection.connect("body_exited", self, "_on_detection_body_exited")


func _physics_process(delta):
	match state:
		State.Move:
			_move(delta)
			
			if Input.is_action_just_pressed("ui_accept"):
				var items = detection.get_overlapping_areas()
				
				if not items.empty():
					interact(items[0])
					
				elif Input.is_action_just_pressed("ui_attack"):
					_start_attack()
				
		State.Interact:
			if interacting_item == null:
				state = State.Move

			if Input.is_action_just_pressed("ui_accept"):
				end_interact(true)
				
			if Input.is_action_just_pressed("ui_cancel"):
				end_interact(false)
				
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
			if time_of_day >= Game.ADULT_AGE:
				_grow_up(Age.Adult)
		Age.Adult:
			if time_of_day >= Game.ELDER_AGE:
				_grow_up(Age.Elder)
	
	
func die():
	Game.add_hero_to_dynasty(self)
	
	if _baby == null:
		Game.game_over()
	else:
		_grow_up_baby()	


func interact(item):
	state = State.Interact	
	interacting_item = item
	interacting_item.start_interaction(self)


func end_interact(answer):
	state = State.Move
	interacting_item.end_interaction(self, answer)
	interacting_item = null
	
	
func knockback(strength):
	motion = motion + strength


func face(direction):
	find_node("AnimationTree").set("parameters/Direction/blend_position", direction)	
	
func _start_attack():
	state = State.Attack
	animationState.travel("Attack")
	

func _end_attack():
	state = State.Move
	animationState.travel("Idle")
	
		
func _move(delta):	
	var input = _get_input()
	
	if input != Vector2.ZERO:
		face(input)
	
	motion = motion.move_toward(input * max_speed, acceleration * delta)
		
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
	parent = _baby.parent
	# todo: set other baby attributes
	
	hp.max_hp = Game.max_hp
	
	_grow_up(Age.Teen)
	baby_sprite.hide()
	_baby = null


func _grow_up(new_age):
	age = new_age	
	animationAge.travel(AGE_ANIMATIONS[age])


