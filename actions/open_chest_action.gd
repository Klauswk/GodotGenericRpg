extends MapAction

class_name OpenChestAction

var map: Node2D
var id: int
var item_id: int
var quantity: int

func initialize(_map: Node2D, _id: int, _item_id: int, _quantity: int):
	map = _map
	id = _id
	item_id = _item_id
	quantity = _quantity	
