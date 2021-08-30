extends CanvasLayer

class_name ItemMenu

onready var itemList: ItemList = $itemList

var character

func _ready():
	itemList.select_mode = ItemList.SELECT_SINGLE
	itemList.hide()
	
func initialize(character: Character ):
	self.character = character

func show_menu():
	itemList.clear()
	for item in character.items:
		print_debug("Item 1: ", item)
		itemList.add_item(str(item.item_name, " x", item.quantity))

	if itemList.get_item_count() > 0:
		itemList.select(0, true)
		
	itemList.show()

func hide_menu():
	itemList.hide()

func visible() -> bool:
	return itemList.visible
