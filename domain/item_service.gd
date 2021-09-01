extends Node

var items = []

var HealingItemClass = load("res://domain/item/healing_item.gd")

func _ready():
	var dir = Directory.new()
	if dir.open("res/items/") == OK:
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
	var file_items = []
	var file = File.new()
	
	file.open(str(path, "/", file_name), file.READ)
	var text_json = file.get_as_text()
	file.close()
	
	var result_json = JSON.parse(text_json)
	
	if result_json.error == OK:  # If parse OK
		file_items = result_json.result
	else:  # If parse has errors
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)
			
	for item in file_items:
		if item.type == 1:
			var healing_item = HealingItemClass.new()
			healing_item.item_name = item.name
			healing_item.id = item.id
			healing_item.value = item.value
			healing_item.usable_type = GameItem.get_usable_type(item.usable_type)
			healing_item.effect = item.effect
			items.append(healing_item)
			
		else:
			print_debug("Not implemented yet")

func find_by_id(id: int) -> GameItem:
	for item in items:
		if item.id == id:
			return item
	return null
	
