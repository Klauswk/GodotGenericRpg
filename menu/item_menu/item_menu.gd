extends CanvasLayer

class_name ItemMenu

onready var itemList: ItemList = $itemList
onready var popupPanel: PopupPanel = $PopupMenu
onready var optionList: ItemList = $PopupMenu/optionList

var character

func _ready():
	itemList.select_mode = ItemList.SELECT_SINGLE
	itemList.set_allow_reselect(true)
	itemList.hide()
	itemList.connect("item_activated", self, "on_item_select")
	optionList.connect("item_activated", self, "on_option_select")
	
func initialize(character: Character ):
	self.character = character

func on_item_select(index: int):
	var item: GameItem = character.items[index]
	
	optionList.clear()
	optionList.add_item("Use")
	optionList.add_item("Exit")
	optionList.grab_focus()
	optionList.select(0, true)
	
	popupPanel.popup()
	

func show_menu():
	itemList.clear()
	for item in character.items:
		itemList.add_item(str(item.item_name, " x", item.quantity))

	if itemList.get_item_count() > 0:
		itemList.grab_focus()
		itemList.select(0, true)
	
	itemList.show()

func hide_menu():
	itemList.hide()

func visible() -> bool:
	return itemList.visible
