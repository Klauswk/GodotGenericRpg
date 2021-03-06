extends Entity

class_name Character

var experience_total = 0
var experience_required = get_required_experience(level)
var bits = 0

var items = []

var open_chests = []

signal level_up(character)

func get_required_experience(level: int):
	return round((50 * (pow(level + 1, 3)))/3 - 100*pow(level + 1,2) + 850*(level + 1)/3 - 200)
	
func increase_experience(amount: int) -> bool:
	var hasLevel = false
	experience_total += amount
	while experience_total >= experience_required:
		hasLevel = true;
		level_up()
	
	return hasLevel

func increase_bits(amount: int):
	bits += amount

func decrease_bits(amount: int):
	bits -= amount
	
func level_up():
	level += 1
	experience_required = get_required_experience(level)
	
	max_hp += 50
	current_hp = max_hp
	strength += randi() % 3
	defense += randi() % 3
	intelligence += randi() % 3
	speed += randi() % 3
	
	emit_signal("level_up", self)

func add_chest_open(id: int):
	open_chests.push_front(id)

func add_item(new_item: GameItem):
	if new_item.id == 0:
		increase_bits(new_item.quantity)
		return
	
	for item in items:
		if item.id == new_item.id:
			item.quantity += new_item.quantity
			return

	items.push_front(new_item)

func remove_item(id: int):
	var position = 0
	for item in items:
		if item.id == id:
			item.quantity -= 1
			if item.quantity == 0:
				items.remove(position)
			break
		position += 1

func is_chest_open(id: int) -> bool:
	return open_chests.has(id)
