extends CanvasLayer

class_name ItemMenu

onready var itemList: ItemList = $itemList
onready var popupPanel: PopupPanel = $PopupMenu
onready var optionList: ItemList = $PopupMenu/optionList

var character: Character
var enemy: Enemy

signal item_use(item, text)

func _ready():
	itemList.select_mode = ItemList.SELECT_SINGLE
	itemList.set_allow_reselect(true)
	itemList.hide()
	itemList.connect("item_activated", self, "on_item_select")
	optionList.connect("item_activated", self, "on_option_select")
	
func initialize(character: Character, enemy: Enemy = null):
	self.character = character
	self.enemy = enemy

func on_option_select(index: int):
	if "Use" in optionList.get_item_text(index):
		var selecteds = itemList.get_selected_items()
		for select in selecteds:
			var item: GameItem = character.items[select]
			
			if enemy != null && item.usable_type == GameItem.USABLE_TYPE.USABLE_BATTLE:
				item.connect("use", self, "on_item_use")
				item.use(character, enemy)
			elif item.usable_type == GameItem.USABLE_TYPE.USABLE_ANYWHERE:
				item.connect("use", self, "on_item_use")
				item.use(character, null)
			
	elif "Exit" in optionList.get_item_text(index):
		popupPanel.hide()
		itemList.grab_focus()

func on_item_use(item: GameItem, text: String):
	character.remove_item(item.id)
	load_item_list()
	popupPanel.hide()
	itemList.grab_focus()
	emit_signal("item_use", item, text)

func on_item_select(index: int):
	var item: GameItem = character.items[index]
	
	optionList.clear()
	optionList.add_item("Use")
	optionList.add_item("Exit")
	optionList.grab_focus()
	optionList.select(0, true)
	
	popupPanel.popup()
	

func show_menu():
	load_item_list()
	
	itemList.show()

func load_item_list():
	itemList.clear()
	for item in character.items:
		itemList.add_item(str(item.item_name, " x", item.quantity))

	focus_on_first()

func focus_on_first():
	if itemList.get_item_count() > 0:
		itemList.grab_focus()
		itemList.select(0, true)

func hide_menu():
	itemList.hide()
	popupPanel.hide()

func visible() -> bool:
	return itemList.visible
