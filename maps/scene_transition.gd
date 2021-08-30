extends Node2D

signal scene_changed()

onready var animation_player = $AnimationPlayer
onready var canvas = $CanvasLayer

func fade():
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")
	
