extends Node

onready var map = $map

onready var player = $player

var last_position_x = 0

var last_position_y = 0

var last_frame = 0

var is_flip = false

var last_map = ""

func _on_player_change_map(next_map, position_x, position_y):
	
	player.position.x = int(position_x)
	player.position.y = int(position_y)
	
	map.get_child(0).queue_free()
	map.add_child(next_map);


func _on_player_battle():
	var battle_scene = preload("res://battle/battle_scene.tscn").instance()
	
	last_map = map.get_child(0).name
	last_position_x = player.position.x
	last_position_y = player.position.y
	last_frame = player.get_frame()
	is_flip = player.is_flip()
	
	player.queue_free()
	map.get_child(0).queue_free()
	add_child(battle_scene);
	
	battle_scene.connect("battle_end", self, "_on_battle_end")
	
func _on_battle_end():
	get_child(1).queue_free()
	
	player = load("res://Player//player.tscn").instance()
	
	var map_name = "res://maps/" + last_map + ".tmx"
	var last_map = load(map_name).instance()
	
	map.add_child(last_map)
	add_child(player)
	player.position.x = last_position_x
	player.position.y = last_position_y	
	player.hasBattle = map.get_meta("battle")
	player.set_frame(last_frame)
	player.set_flip(is_flip)
	
	player.connect("battle", self, "_on_player_battle")
	player.connect("change_map", self, "_on_player_change_map")
