extends MapAction

class_name GotoAction

var position_x: int
var position_y: int

signal change_map(next_scene, position_x, position_y)

func _ready():
	add_to_group("map_actions")

func initialize(_action_name: String,_map: Node2D, _position_x: int, _position_y: int):
	action_name = _action_name
	map = _map
	position_x = _position_x
	position_y = _position_y

func interact():
	var scene_location = "res://maps/" + action_name.right(6) + ".tmx"
	var next_scene = load(scene_location).instance()
	
	print_debug("Changing map to ", action_name.right(6))
	
	emit_signal("change_map", next_scene, position_x, position_y)
