extends KinematicBody2D

class_name Player

const MAX_SPEED = 64;

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer

onready var sprite = $Sprite

onready var collider = $CollisionShape2D

onready var area2D = $Position2D/Area2D

signal collided(collided)

signal battle

export var initial_position_x: int
export var initial_position_y: int

onready var attention_icon = $Attention

var hasBattle = false

var mapAction: MapAction

var pause_input = false

var character: Character = preload("res://domain/character.gd").new()

func _ready():
	position.x = initial_position_x
	position.y = initial_position_y
	
	area2D.connect("body_entered", self, "_on_body_enter")
	area2D.connect("body_exited", self, "_on_body_exited")
	add_to_group("player")

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	var actionPress = false
	
	if !pause_input:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		actionPress = Input.is_action_just_pressed("ui_accept")

	if mapAction != null:
		attention_icon.show()
	else:
		attention_icon.hide()
		
	if mapAction != null && actionPress:
		print_debug("Map action: ", mapAction)
		mapAction.interact()
	elif input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animationPlayer.play("RunRight")
		elif input_vector.x < 0:
			animationPlayer.play("RunLeft")
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

func _on_body_enter(body):
	for action in get_tree().get_nodes_in_group("map_actions"):
		if action == body.get_parent():
			mapAction = body.get_parent()

func _on_body_exited(body):
	for action in get_tree().get_nodes_in_group("map_actions"):
		if action == body.get_parent():
			mapAction = null

