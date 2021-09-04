extends GameItem

class_name CombatItem

func _init():
	effect_type = EFFECT_TYPE.DAMAGE

func use(attacker: Entity, defender: Entity):
	var damage = effect + floor(attacker.strength / 2)
	defender.take_damage(damage)
	emit_signal("use", self, str("Hit ", damage, " to ", defender.combat_name))
