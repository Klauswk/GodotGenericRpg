extends Node

class_name GameItem

enum ITEM_TYPE {USABLE_ANYWHERE, USABLE_BATTLE, SPECIAL}

var item_name: String
var id: int
var type = ITEM_TYPE.USABLE_ANYWHERE
var quantity: int = 1
var value: int = 5

static func findById(item_id: int) -> GameItem:
	var new_item: GameItem = load("res://domain/game_item.gd").new()
	if item_id == 1:
		new_item.item_name = "Potion"
		new_item.id = 1
		new_item.value = 50
	return new_item
