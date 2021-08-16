extends Node

onready var player: Player = $player

var scene

func _ready():
	scene = preload("res://maps/park-central.tmx").instance()
	scene.set_script(preload("res://domain/map_script.gd"))
	scene.player = player
	
	add_child(scene)
	player.connect("collided", self, "_on_collision")
	
func _on_collision(collided: Object):
	var name = collided.get("name");
	
	for action in get_tree().get_nodes_in_group("map_actions"):
		if name in action.action_name:
			action.interact()

func _on_player_battle():
	var battle_scene = preload("res://battle/battle_scene.tscn").instance()
	
	var enemy: Enemy = get_enemy()
	battle_scene.initialize(player.character, get_enemy())
	
	remove_child(scene)
	remove_child(player)
	add_child(battle_scene)
	
	player.character.connect("defeated", self, "_on_player_defeated")
	enemy.connect("defeated", self, "_on_enemy_defeated")
	battle_scene.connect("battle_end", self, "_on_battle_end")
	battle_scene.connect("escape", self, "_on_escape")


func _on_battle_end():
	_on_escape()

func _on_escape():
	for scene in get_tree().get_nodes_in_group("battle_scene"):
		scene.queue_free()

	add_child(scene)
	add_child(player)


func get_enemy() -> Enemy:
	var dict = {}
	var file = File.new()
	
	var current_map = get_tree().get_nodes_in_group("map").front()
		
	var file_location = "res://res/maps/" + current_map.name + ".data"
	
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
