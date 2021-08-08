extends Node2D

signal scene_changed()

onready var animation_player = $AnimationPlayer
onready var canvas = $CanvasLayer

func change_scene(path, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation_player.play_backwards("fade")
