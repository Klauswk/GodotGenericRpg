extends CombatAttribute

class_name Character

var experience_total = 0
var experience_required = get_required_experience(level)

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
