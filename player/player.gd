extends KinematicBody2D

class_name Player

const MAX_SPEED = 64;

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer

onready var sprite = $Sprite

onready var collider = $CollisionShape2D

signal change_map(map, position_x, position_y)

signal battle

export var initial_position_x: int
export var initial_position_y: int

var hasBattle = false

var character: Character = preload("res://domain/character.gd").new()

func _ready():
	position.x = initial_position_x
	position.y = initial_position_y

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animationPlayer.play("RunRight")
			sprite.flip_h = false
		elif input_vector.x < 0:
			sprite.flip_h = true
			animationPlayer.play("RunRight")
		elif input_vector.y > 0:
			animationPlayer.play("Teste")
		elif input_vector.y < 0:
			animationPlayer.play("RunUp")
	
		var shouldHaveBattle = randi() % 100
	
		if shouldHaveBattle == 5:
			print_debug("BATTLE!")
			emit_signal("battle")
			
				
		velocity = input_vector  * MAX_SPEED
	else:
		velocity =	 Vector2.ZERO
		
	var kinematidCollision = move_and_collide(velocity * delta)	
	
	if kinematidCollision != null:
		var collided = kinematidCollision.collider
		var name = collided.get("name");
		var position_x = collided.get_meta("position_x")
		var position_y = collided.get_meta("position_y")
		if "go_to_" in name:
			print_debug("Moving to: " + name);
			var scene_location = "res://maps/" + name.right(6) + ".tmx"
			var next_scene = load(scene_location).instance()
			
			emit_signal("change_map", next_scene, position_x, position_y)
			
func get_frame(): 
	return sprite.frame
	
func set_frame(frame: int):
	sprite.frame = frame

func is_flip():
	return sprite.flip_h

func set_flip(flip: bool):
	sprite.flip_h = flip
