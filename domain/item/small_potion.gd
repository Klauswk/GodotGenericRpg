extends GameItem

class_name SmallPotion

var effect = 50

func _init():
	self.item_name = "Small Potion"
	self.id = 1
	self.value = 50

func use(combatAttribute: Entity):
	if combatAttribute.max_hp == combatAttribute.current_hp:
		pass
	elif combatAttribute.current_hp + effect > combatAttribute.max_hp:
		combatAttribute.current_hp = combatAttribute.max_hp
		emit_signal("use", self)
	else:
		combatAttribute.current_hp += effect
		emit_signal("use", self)
