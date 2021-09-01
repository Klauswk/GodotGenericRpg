extends GameItem

class_name HealingItem

func _init():
	effect_type = EFFECT_TYPE.HEALING

func use(combatAttribute: Entity):
	if combatAttribute.max_hp == combatAttribute.current_hp:
		pass
	elif combatAttribute.current_hp + effect > combatAttribute.max_hp:
		combatAttribute.current_hp = combatAttribute.max_hp
		emit_signal("use", self)
	else:
		combatAttribute.current_hp += effect
		emit_signal("use", self)
