extends Node

class_name MapAction

var map: Node2D
var action_name: String

signal finished

func interact():
	print("No implementation for this method")
	emit_signal("finished")
