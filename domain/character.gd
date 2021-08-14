extends CombatAttribute

class_name Character

var experience = 0
var experience_total = 0
var experience_required = get_required_experience(level + 1)

signal level_up(character)

func get_required_experience(level: int):
	return round(pow(level, 1.8) + level * 4)
	
func increase_experience(amount: int):
	experience_total += amount
	experience += amount
	while experience >= experience_required:
		level_up()
		experience =- experience_required
		
func level_up():
	level =+ 1
	experience_required = get_required_experience(level + 1)
	
	max_hp += 50
	strength += randi() % 3
	defense += randi() % 3
	intelligence += randi() % 3
	speed += randi() % 3
	
	emit_signal("level_up", self)
