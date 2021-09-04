extends Resource

class_name GameItem

enum USABLE_TYPE {USABLE_ANYWHERE, USABLE_BATTLE, SPECIAL}
enum EFFECT_TYPE {HEALING, DAMAGE}

signal use(item, message)

var item_name: String
var id: int
var usable_type
var effect_type
var effect
var quantity: int = 1
var value: int

static func get_usable_type(id: int):
	match id:
		1:
			return USABLE_TYPE.USABLE_ANYWHERE
		2:
			return USABLE_TYPE.USABLE_BATTLE
		_:
			return USABLE_TYPE.SPECIAL

func use(attacker: Entity, defender: Entity):
	print_debug("No implementation for this")
