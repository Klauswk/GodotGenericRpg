extends Node

var enemies = {}

var Enemy = preload("res://domain/enemy.gd")

func _ready():
	var dir = Directory.new()
	if dir.open("res/maps/") == OK:
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				print("Found file: " + file_name)
				load_file_content(file_name,dir.get_current_dir())
				file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func load_file_content(file_name: String, path: String):
	var dict = {}
	var file = File.new()
	
	file.open(str(path, "/", file_name), file.READ)
	var text_json = file.get_as_text()
	file.close()
	
	var result_json = JSON.parse(text_json)
	
	if result_json.error == OK:  # If parse OK
		dict = result_json.result
	else:  # If parse has errors
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)
	
	var load_enemies: Array = dict.get("enemies")
	var enemies_to_fight: Array = []
		
	for enemy_to_fight in load_enemies:
		var enemy: Enemy = Enemy.new()
		enemy.combat_name = enemy_to_fight.get("combat_name")
		enemy.max_hp = enemy_to_fight.get("max_hp")
		enemy.current_hp = enemy_to_fight.get("max_hp")
		enemy.level = enemy_to_fight.get("level")
		enemy.strength = enemy_to_fight.get("strength")
		enemy.defense = enemy_to_fight.get("defense")
		enemy.speed = enemy_to_fight.get("speed")
		enemy.intelligence = enemy_to_fight.get("intelligence")
		enemy.experience = enemy_to_fight.get("experience")
		enemy.bits = enemy_to_fight.get("bits")
		enemies_to_fight.append(enemy)
		
	enemies[file_name.split(".")[0]] = enemies_to_fight
	

func get_enemy(map_name: String) -> Enemy:	
	var enemies_array: Array = enemies.get(map_name)
	
	var random_enemy = randi() % enemies_array.size() - 1
	
	var main_enemy: Enemy = enemies_array[random_enemy]
	var enemy_to_fight = main_enemy.duplicate()
	
	enemy_to_fight.experience = main_enemy.experience
	enemy_to_fight.bits = main_enemy.bits

	return enemy_to_fight
