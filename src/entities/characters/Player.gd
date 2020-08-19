extends KinematicBody2D


const RACE_TEXTURES = {
	"human": preload("res://assets/sprites/hero.png"),
	"orc": preload("res://assets/sprites/orc_babies.png"),
	"elf": preload("res://assets/sprites/elf.png"),
}

const HP = preload("res://src/components/HP.gd")

enum State {
	Move,
	Interact,
	Attack,
}

export var sprite_width = 32
export var sprite_height = 32
export var total_frames = 10

export(String, "Right", "Left", "Up", "Down") var facing_direction = "Down" setget _set_facing_direction
export(String, "Teen", "Adult", "Elder") var age = "Teen" setget _set_age

export var max_hp = 10 setget _set_max_hp

var acceleration: float = 400
var max_speed: float = 80

var motion: Vector2 = Vector2.ZERO

var interacting_item = null
var state = State.Move

var hp = HP.new(max_hp)
var baby = null

var parent = ""
var race = "human"

onready var detection : Area2D = $DetectionBox
onready var baby_sprite : Sprite = $BabySprite

onready var animationTree = $AnimationTree
onready var animationAge = animationTree.get("parameters/Age/playback")
onready var animationState = animationTree.get("parameters/Action/playback")


func init(from_parent):
	if Engine.editor_hint:
		return

	parent = from_parent			


func _ready():
	if Engine.editor_hint:
		return
	
	Game.connect("time_passes", self, "_on_time_passes")
	
	detection.connect("body_entered", self, "_on_detection_body_entered")
	detection.connect("body_exited", self, "_on_detection_body_exited")

	baby_sprite.hide()
	
	set_sprite_sheet()
	
	animationTree.active = true

func _physics_process(delta):
	if Engine.editor_hint:
		return
	
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
	
	
func have_child(new_baby):
	if has_child():
		return
	
	baby = new_baby
	baby_sprite.set_texture(RACE_TEXTURES[baby.race])
	baby_sprite.show()


func has_child():
	return baby != null


func is_in_reproductive_age():
	return age == "Adult" or age == "Elder"
			
	
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
	
	if input == Vector2.ZERO:
		animationState.travel("Idle")
	else:
		animationState.travel("Walk")
		face(input)
	
	motion = motion.move_toward(input * max_speed, acceleration * delta)
		
	motion = move_and_slide(motion)


func _get_input() -> Vector2:
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input == Vector2.ZERO:
		input = Vector2.ZERO
		
	return input.normalized()

		
func _on_time_passes(time_of_day):
	var current_age = animationAge.get_current_node()
	match current_age:
		"Teen":
			if time_of_day >= Game.ADULT_AGE:
				animationAge.travel("Adult")
		"Adult":
			if time_of_day >= Game.ELDER_AGE:
				animationAge.travel("Elder")


func _set_max_hp(new_max_hp):
	max_hp = new_max_hp
	hp.max_hp = max_hp
	
	
func _set_age(new_age):
	if new_age == "" or new_age == age:
		return
	
	age = new_age
	set_sprite_sheet()
	

func _set_facing_direction(new_direction):
	if new_direction == "" or facing_direction == new_direction:
		return
	facing_direction = new_direction
	
	set_sprite_sheet()

	
func set_sprite_sheet():
	var sprite = find_node("Sprite")
	
	if sprite == null:
		return
		
	var size = Vector2(sprite_width * total_frames, sprite_height)
	
	var ages = ["Teen", "Adult", "Elder"]
	var age_index = ages.find(age)
	var age_offset = age_index * size.y
	
	var directions = ["Right", "Left", "Down", "Up"]
	var direction_index = directions.find(facing_direction)
	var direction_offset = size.y * 3 * direction_index
		
	var pos = Vector2(0, age_offset + direction_offset)
	
	sprite.region_rect = Rect2(pos, size)
	sprite.hframes = total_frames
	
	if baby_sprite == null:
		return 
		
	var baby_pos = Vector2(0, direction_offset)
	var baby_size = Vector2(sprite_width, sprite_height)
	
	baby_sprite.region_rect = Rect2(baby_pos, baby_size)


