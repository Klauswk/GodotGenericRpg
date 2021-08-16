extends MapAction

class_name GotoAction

var position_x: int
var position_y: int
var player: Player

signal change_map(next_scene, position_x, position_y)

func _ready():
	add_to_group("map_actions")

func initialize(_action_name: String, _position_x: int, _position_y: int, _player: Player):
	action_name = _action_name
	position_x = _position_x
	position_y = _position_y
	player = _player

func interact():
	var scene_location = "res://maps/" + action_name.right(6) + ".tmx"
	var next_scene = load(scene_location).instance()
	
	next_scene.set_script(preload("res://domain/map_script.gd"))
	next_scene.player = player
	
	print_debug("Changing map to ", action_name.right(6))
	
	emit_signal("change_map", next_scene, position_x, position_y)
