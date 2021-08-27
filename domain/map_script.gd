extends Node

var player: Player
var textBox: GameTextBox

func _ready():
	add_to_group("map")
	load_map_info()

func initialize(_player: Player):
	player = _player

func load_map_info():
	player.hasBattle = has_meta("battle")
	
	for object in get_children():
		process_node(object)

func process_node(node: Node):
	if "actions" in node.name:
		for action in node.get_children():
			create_action(action)

func _input(event):
	if self.player.pause_input:
		if event.is_action_pressed("ui_accept"):
			textBox.nextText()
		

func create_action(action):
	
	var new_action = null
	
	if "Chest" in action.name:
		new_action = preload("res://chest/chest.tscn").instance()
		new_action.position.x = action.position.x + 8
		new_action.position.y = action.position.y + 8
		new_action.initialize(action.name, int(action.get_meta("id")), int(action.get_meta("item_id")), int(action.get_meta("quantity")))
		new_action.connect("text_show", self,"_on_text_show")
		action.queue_free()
	elif "go_to" in action.name:
		new_action = load("res://actions/go_to_action.gd").new()
		new_action.initialize(action.name, int(action.get_meta("position_x")), int(action.get_meta("position_y")), player, textBox)
		new_action.connect("change_map", self, "_on_player_change_map")
	elif "npc" in action.name:
		new_action = preload("res://save_robot/save_robot.tscn").instance()
		new_action.position.x = action.position.x + 8
		new_action.position.y = action.position.y + 8
		new_action.connect("text_show", self,"_on_text_show")
	
	new_action.name = action.name
	add_child(new_action)


func _on_player_change_map(next_map, position_x, position_y):
	
	player.position.x = int(position_x)
	player.position.y = int(position_y)
	player.hasBattle = next_map.has_meta("battle")
	
	for scene in get_tree().get_nodes_in_group("map"):
		scene.queue_free()
	
	clear_map_info()
	
	for game in get_tree().get_nodes_in_group("game"):
		game.add_child(next_map)
		game.scene = next_map
	
func _on_text_show(text: String):
	self.textBox.set_text(text)
	self.player.pause_input = true
	yield(self.textBox, "finished")
	self.player.pause_input = false

func clear_map_info():
	for action in get_tree().get_nodes_in_group("map_actions"):
		action.queue_free()
