extends MapAction

class_name OpenChestAction

var id: int
var item_id: int
var quantity: int

func _ready():
	add_to_group("map_actions")

func initialize(_action_name: String, _map: Node2D, _id: int, _item_id: int, _quantity: int):
	action_name = _action_name
	map = _map
	id = _id
	item_id = _item_id
	quantity = _quantity	
