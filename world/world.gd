extends Node

onready var map: Node2D = $map

onready var player: Player = $player

func _ready():
	var tilemap = map.get_child(0)
	
	for object in tilemap.get_children():
		process_node(object)
	
	player.connect("collided", self, "_on_collision")
	
func process_node(node: Node):
	if "actions" in node.name:
		for action in node.get_children():
			create_action(action)

func create_action(action):
	
	var new_action = null
	
	if "Chest" in action.name:
		var chest = preload("res://chest/chest.tscn").instance()
		new_action = preload("res://actions/open_chest_action.gd").new()
		new_action.initialize(action.name, map, int(action.get_meta("id")), int(action.get_meta("item_id")), int(action.get_meta("quantity")))
		action.add_child(chest)
	elif "go_to" in action.name:
		new_action = preload("res://actions/go_to_action.gd").new()
		new_action.initialize(action.name, map, int(action.get_meta("position_x")), int(action.get_meta("position_y")))
		new_action.connect("change_map", self, "_on_player_change_map")
	
	add_child(new_action)
	
func _on_collision(collided: Object):
	var name = collided.get("name");
	print_debug("collided ", name)
	print_debug("nodes in group: ", get_tree().get_nodes_in_group("map_actions").size())
	
	for action in get_tree().get_nodes_in_group("map_actions"):
		print_debug("action name ", action.action_name)
		if name in action.action_name:
			action.interact()


func _on_player_change_map(next_map, position_x, position_y):
	
	player.position.x = int(position_x)
	player.position.y = int(position_y)
	
	map.get_child(0).queue_free()
	map.add_child(next_map);

func _on_player_battle():
	var battle_scene = preload("res://battle/battle_scene.tscn").instance()
	
	var enemy: Enemy = get_enemy()
	battle_scene.initialize(player.character, get_enemy())
	remove_child(map)
	remove_child(player)
	add_child(battle_scene)
	
	player.character.connect("defeated", self, "_on_player_defeated")
	enemy.connect("defeated", self, "_on_enemy_defeated")
	battle_scene.connect("battle_end", self, "_on_battle_end")
	battle_scene.connect("escape", self, "_on_escape")


func _on_battle_end():
	_on_escape()

func _on_escape():
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
