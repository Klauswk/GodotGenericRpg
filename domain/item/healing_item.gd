extends GameItem

class_name HealingItem

func _init():
	effect_type = EFFECT_TYPE.HEALING

func use(attacker: Entity, defender: Entity):
	if attacker.max_hp == attacker.current_hp:
		pass
	elif attacker.current_hp + effect > attacker.max_hp:
		attacker.current_hp = attacker.max_hp
		emit_signal("use", self, str("Healed ", effect, " hp"))
	else:
		attacker.current_hp += effect
		emit_signal("use", self, str("Healed ", effect, " hp"))
