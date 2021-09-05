extends CanvasLayer

onready var shop_options = $shop_panel/shop_options
onready var shop_list = $shop_panel/shopList
onready var player_list = $shop_panel/playerList
onready var shop_panel = $shop_panel

onready var btnBuy = $shop_panel/shop_options/HBoxContainer/btnBuy
onready var btnSell= $shop_panel/shop_options/HBoxContainer/btnSell

onready var buy_sub_menu = $shop_panel/shopList/buy_sub_menu
onready var sell_sub_menu = $shop_panel/playerList/sell_sub_menu

onready var shopOptionList = $shop_panel/shopList/buy_sub_menu/optionList
onready var sellOptionList = $shop_panel/playerList/sell_sub_menu/optionList

var character: Character

signal shop_close

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if shop_list.visible:
			shop_list.hide()
			shop_options.show()
			btnBuy.grab_focus()
		elif player_list.visible:
			player_list.hide()
			shop_options.show()
			btnSell.grab_focus()
		elif shop_options.visible:
			hide_menu()
			emit_signal("shop_close")
			

func initialize(character: Character ):
	self.character = character

func _ready():
	shop_panel.hide()
	shop_options.hide()
	shop_list.hide()
	player_list.hide()
	
	shop_list.select_mode = ItemList.SELECT_SINGLE
	shop_list.set_allow_reselect(true)
	shop_list.connect("item_activated", self, "on_item_buy_select")
	shopOptionList.connect("item_activated", self, "on_option_buy_select")
	
	player_list.select_mode = ItemList.SELECT_SINGLE
	player_list.set_allow_reselect(true)
	player_list.connect("item_activated", self, "on_item_sell_select")
	sellOptionList.connect("item_activated", self, "on_option_sell_select")
	
	shop_list.clear()
	var count = 0
	for item in ItemService.items:
		if item.usable_type != GameItem.USABLE_TYPE.SPECIAL:
			shop_list.add_item(str(item.item_name, " - ", item.value, " bits"))
			shop_list.set_item_metadata(count, item)
			count += 1
	
	shopOptionList.clear()
	shopOptionList.add_item("Buy")
	shopOptionList.add_item("Exit")
	
	sellOptionList.clear()	
	sellOptionList.add_item("Sell")
	sellOptionList.add_item("Exit")
	
	btnBuy.connect("pressed", self, "_on_btn_buy_pressed")
	btnSell.connect("pressed", self, "_on_btn_sell_pressed")

func _on_btn_buy_pressed():
	shop_options.hide()
	shop_list.show()
	focus_on_first(shop_list)
	
	
func _on_btn_sell_pressed():
	shop_options.hide()
	
	update_sell_list()
	player_list.show()
	
	focus_on_first(player_list)

func update_sell_list():
	player_list.clear()
	var count = 0
	for item in character.items:
		player_list.add_item(str(item.item_name, " - ", item.value * 0.2, " bits"))
		player_list.set_item_metadata(count, item)
		count += 1

func on_item_buy_select(index: int):
	var item: GameItem = ItemService.items[index]
	shopOptionList.grab_focus()
	shopOptionList.select(0, true)
	
	buy_sub_menu.popup()

func on_option_buy_select(index: int):
	if "Buy" in shopOptionList.get_item_text(index):
		var selected = shop_list.get_selected_items()
		
		var item: GameItem = shop_list.get_item_metadata(selected[0])

		if self.character.bits >= item.value:
			self.character.decrease_bits(item.value)
			self.character.add_item(ItemService.build_new_item(item))
			buy_sub_menu.hide()
			shop_list.grab_focus()
			
	elif "Exit" in shopOptionList.get_item_text(index):
		buy_sub_menu.hide()
		shop_list.grab_focus()

func on_item_sell_select(index: int):
	var item: GameItem = character.items[index]
	sellOptionList.grab_focus()
	sellOptionList.select(0, true)
	
	sell_sub_menu.popup()

func on_option_sell_select(index: int):
	if "Sell" in sellOptionList.get_item_text(index):
		var selected = player_list.get_selected_items()
		
		var item: GameItem = character.items[selected[0]]
		
		self.character.remove_item(item.id)
		self.character.increase_bits(item.value * 0.2)
		update_sell_list()
		sell_sub_menu.hide()
		player_list.grab_focus()
			
	elif "Exit" in shopOptionList.get_item_text(index):
		sell_sub_menu.hide()
		shop_list.grab_focus()

func show_menu():
	shop_panel.show()
	shop_options.show()
	btnBuy.grab_focus()

func hide_menu():
	shop_panel.hide()
	shop_options.hide()
	shop_list.hide()
	player_list.hide()


func focus_on_first(itemList: ItemList):
	if itemList.get_item_count() > 0:
		itemList.grab_focus()
		itemList.select(0, true)

func visible() -> bool:
	return shop_panel.visible
