extends Node

class_name MapAction

var map: Node2D
var action_name: String
var interactive_area: Area2D

signal finished
signal text_show(text)

func _ready():
	add_to_group("map_actions")

func interact():
	print("No implementation for this method")
	emit_signal("finished")

func get_class():
	return "MapAction"
