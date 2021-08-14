extends Node

onready var map = $map

onready var player = $player

func _on_player_change_map(next_map, position_x, position_y):
	
	player.position.x = int(position_x)
	player.position.y = int(position_y)
	
	map.get_child(0).queue_free()
	map.add_child(next_map);
	

func _on_player_battle():
	var battle_scene = preload("res://battle/battle_scene.tscn").instance()
	var character = preload("res://domain/character.gd").new()
	
	battle_scene.initialize(character, get_enemy())
	remove_child(map)
	remove_child(player)
	add_child(battle_scene)
	
	battle_scene.connect("battle_end", self, "_on_battle_end")
	
func _on_battle_end():
	get_child(0).queue_free()

	add_child(map)
	add_child(player)

func get_enemy() -> Enemy:
	var dict = {}
	var file = File.new()
	var file_location = "res://res/maps/" + map.get_child(0).name + ".data"
	
	print_debug("File location: " + file_location)
	
	file.open(file_location, file.READ)
	var text_json = file.get_as_text()
	file.close()
	
	var result_json = JSON.parse(text_json)
	var enemy: Enemy = preload("res://domain/enemy.gd").new()
	
	if result_json.error == OK:  # If parse OK
		dict = result_json.result
	else:  # If parse has errors
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)
	
	var enemies: Array = dict.get("enemies")
	
	var random_enemy = randi() % enemies.size() - 1
	
	var enemy_to_fight = enemies[random_enemy]
	
	enemy.combat_name = enemy_to_fight.get("combat_name")
	enemy.max_hp = enemy_to_fight.get("max_hp")
	enemy.current_hp = enemy_to_fight.get("max_hp")
	enemy.level = enemy_to_fight.get("level")
	enemy.strength = enemy_to_fight.get("strength")
	enemy.defense = enemy_to_fight.get("defense")
	enemy.speed = enemy_to_fight.get("speed")
	enemy.intelligence = enemy_to_fight.get("intelligence")
	enemy.experience = enemy_to_fight.get("experience")
	
	return enemy
