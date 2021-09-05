extends Resource

class_name GameItem

enum USABLE_TYPE {USABLE_ANYWHERE = 1, USABLE_BATTLE = 2, SPECIAL = 3}
enum EFFECT_TYPE {NONE = 0, HEALING = 1, DAMAGE = 2}

signal use(item, message)

var item_name: String
var id: int = 0
var usable_type = USABLE_TYPE.SPECIAL
var effect_type = EFFECT_TYPE.NONE
var effect = 0
var quantity: int = 1
var value: int = 0

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
