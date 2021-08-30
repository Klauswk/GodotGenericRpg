extends MapAction

class_name OpenChestAction

signal item_acquired(chest_id, item_id, _quantity)

var id: int
var item_id: int
var quantity: int

func initialize(_action_name: String, _id: int, _item_id: int, _quantity: int):
	action_name = _action_name
	id = _id
	item_id = _item_id
	quantity = _quantity
