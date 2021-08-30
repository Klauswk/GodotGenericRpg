extends Node

onready var player: Player = $player
onready var textbox: GameTextBox = $textbox
onready var gameMenu: GameMenu = $menu
onready var statusMenu = $status_menu
onready var itemMenu = $item_menu

var Scene_Transition = preload("res://maps/scene_transition.tscn")

var Battle_Scene = preload("res://battle/battle_scene.tscn")

var scene

var on_battle = false

func _ready():
	scene = preload("res://maps/park-central.tmx").instance()
	scene.set_script(load("res://domain/map_script.gd"))
	scene.player = player
	scene.textBox = textbox
	
	add_child(scene)
	player.connect("collided", self, "_on_collision")
	gameMenu.connect("open", self, "_on_menu_open")
	gameMenu.connect("close", self, "_on_menu_close")
	gameMenu.connect("open_status", self, "_on_status_open")
	gameMenu.connect("open_item", self, "_on_item_open")
	

func _input(event):
	if self.player.pause_input:
		if event.is_action_pressed("ui_accept") || event.is_action_pressed("ui_cancel"):
			textbox.nextText()
	if (!gameMenu.visible()) && event.is_action_pressed("ui_select") && (!on_battle) && (!statusMenu.visible()):
		_on_menu_open()
		gameMenu.show_menu()
	elif gameMenu.visible() && (event.is_action_pressed("ui_cancel") || event.is_action_pressed("ui_select")) && (!on_battle):
		_on_menu_close()
		gameMenu.hide_menu()
	elif statusMenu.visible() && (event.is_action_pressed("ui_cancel") || event.is_action_pressed("ui_select")) && (!on_battle):
		statusMenu.hide_menu()
		gameMenu.show_menu()
	elif itemMenu.visible() && (event.is_action_pressed("ui_cancel") || event.is_action_pressed("ui_select")) && (!on_battle):
		itemMenu.hide_menu()
		gameMenu.show_menu()

func _on_menu_open():
	self.player.pause_input = true

func _on_menu_close():
	self.player.pause_input = false

func _on_collision(collided: Object):
	var name = collided.get("name");
	
	for action in get_tree().get_nodes_in_group("map_actions"):
		if name in action.action_name:
			action.interact()

func _on_status_open():
	gameMenu.hide_menu()
	statusMenu.initialize(player.character)
	statusMenu.show_menu()

func _on_item_open():
	gameMenu.hide_menu()
	itemMenu.initialize(player.character)
	itemMenu.show_menu()

func _on_player_battle():
	self.player.pause_input = true
	on_battle = true
	
	var scene_transition = Scene_Transition.instance()
	add_child(scene_transition)
	scene_transition.fade()
	
	yield(scene_transition,"scene_changed")
	
	var battle_scene = Battle_Scene.instance()
	
	var current_map = get_tree().get_nodes_in_group("map").front()
	
	var enemy: Enemy = Enemy.get_enemy(current_map.name)
	battle_scene.initialize(player.character, enemy)
	
	remove_child(scene)
	remove_child(player)
	remove_child(gameMenu)
	add_child(battle_scene)
	remove_child(scene_transition)
	
	battle_scene.connect("battle_end", self, "_on_battle_end")
	battle_scene.connect("escape", self, "_on_escape")


func _on_battle_end():
	on_battle = false
	_on_escape()

func _on_escape():
	for scene in get_tree().get_nodes_in_group("battle_scene"):
		scene.queue_free()

	self.player.pause_input = false
	add_child(scene)
	add_child(player)
	add_child(gameMenu)


