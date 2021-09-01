extends Node

var player: Player
var textBox: GameTextBox

signal open_shop

func _ready():
	add_to_group("map")
	load_map_info()

func initialize(_player: Player):
	player = _player

func load_map_info():
	player.hasBattle = has_meta("battle")
	
	var tilemap = get_node("Map");
	
	if tilemap != null:
		var map_limits = tilemap.get_used_rect()
		var map_cellsize = tilemap.cell_size
		
		for camera in get_tree().get_nodes_in_group("camera"):
			if camera is Camera2D:
				camera.limit_left = map_limits.position.x * map_cellsize.x
				camera.limit_right = map_limits.end.x * map_cellsize.x
				camera.limit_top = map_limits.position.y * map_cellsize.y
				camera.limit_bottom = map_limits.end.y * map_cellsize.y
	
	for object in get_children():
		process_node(object)

func process_node(node: Node):
	if "actions" in node.name:
		for action in node.get_children():
			create_action(action)

func create_action(action):
	
	var new_action = null
	
	action.position.y -= 8
	
	if "Chest" in action.name:
		
		if !player.character.is_chest_open(int(action.get_meta("id"))):
			new_action = preload("res://chest/chest.tscn").instance()
			new_action.position.x = action.position.x
			new_action.position.y = action.position.y
			new_action.initialize(action.name, int(action.get_meta("id")), int(action.get_meta("item_id")), int(action.get_meta("quantity")))
			new_action.connect("text_show", self,"_on_text_show")
			new_action.connect("item_acquired", self,"_on_item_acquired")
			new_action.name = action.name
			add_new_action(new_action)
			
		action.queue_free()
	elif "go_to" in action.name:
		new_action = load("res://actions/go_to_action.gd").new()
		new_action.initialize(action.name, int(action.get_meta("position_x")), int(action.get_meta("position_y")), player, textBox)
		new_action.connect("change_map", self, "_on_player_change_map")
		new_action.name = action.name
		add_new_action(new_action)
		
	elif "npc" in action.name:
		if "save" in action.name:
			new_action = preload("res://save_robot/save_robot.tscn").instance()
			new_action.initialize(name, player)
			new_action.position.x = action.position.x
			new_action.position.y = action.position.y
			new_action.connect("text_show", self,"_on_text_show")
			new_action.name = action.name
			add_new_action(new_action)
		elif "shop" in action.name:
			new_action = preload("res://shop/shop_npc.tscn").instance()
			new_action.position.x = action.position.x
			new_action.position.y = action.position.y
			new_action.name = action.name
			new_action.connect("open_shop", self,"_on_open_shop")
			add_new_action(new_action)

func add_new_action(mapAction: MapAction):
	add_child(mapAction)

func _on_open_shop():
	emit_signal("open_shop")

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

func _on_item_acquired(id, item_id, _quantity):
	player.character.add_chest_open(id)
	var item = ItemService.find_by_id(item_id)
	item.quantity = _quantity
	player.character.add_item(item)

func clear_map_info():
	for action in get_tree().get_nodes_in_group("map_actions"):
		action.queue_free()
