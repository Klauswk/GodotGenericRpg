extends Resource

class_name GameItem

enum ITEM_TYPE {USABLE_ANYWHERE, USABLE_BATTLE, SPECIAL}

signal use(item)

var item_name: String
var id: int
var type = ITEM_TYPE.USABLE_ANYWHERE
var quantity: int = 1
var value: int = 5

static func findById(item_id: int) -> GameItem:
	match item_id:
		1:
			return load("res://domain/item/small_potion.gd").new()
		_:
			return null

func use(combatAttribute: Entity):
	print_debug("No implementation for this")
