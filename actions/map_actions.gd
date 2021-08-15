extends Node

class_name MapAction

signal finished
var local_map

func _ready():
	add_to_group("map_action")

func interact():
	print("No implementation for this method")
	emit_signal("finished")
