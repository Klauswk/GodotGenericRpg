extends KinematicBody2D

const MAX_SPEED = 64;

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer

onready var sprite = $Sprite

onready var collider = $CollisionShape2D

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
			print_debug("vamos para: " + position_x);
			var scene_location = "res://maps/" + name.right(6) + ".tmx"
			var next_scene = load(scene_location).instance()
			
			position.x = int(position_x)
			position.y = int(position_y)
			
			var world = get_tree().root.get_child(0);
			
			world.get_child(0).free()
			world.add_child(next_scene);
			world.move_child(next_scene, 0)
			
			
			#get_tree().get("park_central");
			#get_tree().change_scene_to(next_scene)
