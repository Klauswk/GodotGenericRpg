extends Node

class_name GameItem

var item_name
var id
var type
var quantity

static func findById(item_id: int) -> GameItem:
	var new_item: GameItem = load("res://domain/game_item.gd").new()
	if item_id == 1:
		new_item.item_name = "Potion"
		new_item.id = 1
		new_item.quantity = 1
	return new_item
