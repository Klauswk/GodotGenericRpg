extends CombatAttribute

class_name Enemy

var experience = 0


static func get_enemy(map_name: String) -> Enemy:
	var dict = {}
	var file = File.new()

	var file_location = "res://res/maps/" + map_name + ".data"
	
	file.open(file_location, file.READ)
	var text_json = file.get_as_text()
	file.close()
	
	var result_json = JSON.parse(text_json)
	var enemy: Enemy = load("res://domain/enemy.gd").new()
	
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
