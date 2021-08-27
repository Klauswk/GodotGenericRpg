extends Node

onready var player: Player = $player
onready var textbox: GameTextBox = $textbox

var scene

func _ready():
	scene = preload("res://maps/park-central.tmx").instance()
	scene.set_script(load("res://domain/map_script.gd"))
	scene.player = player
	scene.textBox = textbox
	
	add_child(scene)
	player.connect("collided", self, "_on_collision")
	
func _on_collision(collided: Object):
	var name = collided.get("name");
	
	for action in get_tree().get_nodes_in_group("map_actions"):
		if name in action.action_name:
			action.interact()

func _on_player_battle():
	var battle_scene = preload("res://battle/battle_scene.tscn").instance()
	
	var current_map = get_tree().get_nodes_in_group("map").front()
	
	var enemy: Enemy = Enemy.get_enemy(current_map.name)
	battle_scene.initialize(player.character, enemy)
	
	remove_child(scene)
	remove_child(player)
	add_child(battle_scene)
	
	battle_scene.connect("battle_end", self, "_on_battle_end")
	battle_scene.connect("escape", self, "_on_escape")


func _on_battle_end():
	_on_escape()

func _on_escape():
	for scene in get_tree().get_nodes_in_group("battle_scene"):
		scene.queue_free()

	add_child(scene)
	add_child(player)


