extends Control

signal battle_end

onready var btnNewGame = $MarginContainer/Menu/CenterRow/VBoxContainer/btnNewGame
onready var btnLoad = $MarginContainer/Menu/CenterRow/VBoxContainer/btnLoad

func _ready():
	var save_game = File.new()
	if not save_game.file_exists("user://DW2023.save"):
		btnNewGame.grab_focus()
	else:
		btnLoad.grab_focus()
	
	btnNewGame.connect("pressed", self, "_on_btn_new_game")
	btnLoad.connect("pressed", self, "_on_btn_load")
	
func _on_btn_new_game():
	var main_world = preload("res://world/main_world.tscn").instance()
	
	get_tree().get_root().add_child(main_world)
	main_world.set_map_scene(load("res://maps/park-central.tmx").instance())
	
	get_tree().get_root().remove_child(self)

func _on_btn_load():
	
	var save_game = File.new()
	if save_game.file_exists("user://DW2023.save"):
		save_game.open("user://DW2023.save", File.READ)
		
		var game_data = parse_json(save_game.get_as_text())
		
		save_game.close()
		
		var main_world = preload("res://world/main_world.tscn").instance()
		
		
		get_tree().get_root().add_child(main_world)
		var player = main_world.player
		player.position.x = game_data.position_x
		player.position.y = game_data.position_y
		player.character.level = game_data.level
		player.character.max_hp = game_data.max_hp
		player.character.strength = game_data.strength
		player.character.defense = game_data.defense
		player.character.intelligence = game_data.intelligence
		player.character.speed = game_data.speed
		player.character.current_hp = game_data.current_hp
		player.character.experience_total = game_data.experience_total
		player.character.experience_required = player.character.get_required_experience(player.character.level)
		main_world.set_map_scene(load(str("res://maps/",game_data.location,".tmx")).instance())
		
		get_tree().get_root().remove_child(self)
		
		
