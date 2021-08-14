extends CombatAttribute

class_name Character

var experience = 0
var experience_total = 0
var experience_required = get_required_expirience(level + 1)

func get_required_expirience(level: int):
	return round(pow(level, 1.8) + level * 4)
	
func increase_experience(amount: int):
	experience_total += amount
	experience += amount
	while experience >= experience_required:
		level_up()
		experience =- experience_required
		
		
func level_up():
	level =+ 1
	experience_required = get_required_expirience(level + 1)
	
	var stats = ["max_hp", "strength","defense","intelligence", "speed"]
	var random_stats = stats[randi() % stats.size()]
	set(random_stats, stats[random_stats] + (randi() % 3) + 2)
	
