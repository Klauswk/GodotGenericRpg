extends CanvasLayer

onready var shop_options = $shop_panel/shop_options
onready var shop_list = $shop_panel/shopList
onready var player_list = $shop_panel/playerList
onready var shop_panel = $shop_panel
onready var btnBuy = $shop_panel/shop_options/HBoxContainer/btnBuy
onready var btnSell= $shop_panel/shop_options/HBoxContainer/btnSell

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
			

func _ready():
	shop_panel.hide()
	shop_options.hide()
	shop_list.hide()
	player_list.hide()
	
	btnBuy.connect("pressed", self, "_on_btn_buy_pressed")
	btnSell.connect("pressed", self, "_on_btn_sell_pressed")

func _on_btn_buy_pressed():
	shop_options.hide()
	shop_list.show()
	
func _on_btn_sell_pressed():
	shop_options.hide()
	player_list.show()

func show_menu():
	shop_panel.show()
	shop_options.show()
	btnBuy.grab_focus()

func hide_menu():
	shop_panel.hide()
	shop_options.hide()
	shop_list.hide()
	player_list.hide()

func visible() -> bool:
	return shop_panel.visible
