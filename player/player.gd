extends KinematicBody2D

class_name Player

const MAX_SPEED = 64;

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer

onready var sprite = $Sprite

onready var collider = $CollisionShape2D

signal collided(collided)

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
	
		if hasBattle:
			var shouldHaveBattle = randi() % 100
			if shouldHaveBattle == 5:
				emit_signal("battle")
			
				
		velocity = input_vector  * MAX_SPEED
	else:
		velocity =	 Vector2.ZERO
		
	var kinematidCollision = move_and_collide(velocity * delta)	
	
	if kinematidCollision != null:
		emit_signal("collided", kinematidCollision.collider)
			
func get_frame(): 
	return sprite.frame
	
func set_frame(frame: int):
	sprite.frame = frame

func is_flip():
	return sprite.flip_h

func set_flip(flip: bool):
	sprite.flip_h = flip
