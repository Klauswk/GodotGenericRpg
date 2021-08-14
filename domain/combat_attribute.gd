extends Node

class_name CombatAttribute

export (int) var level = 1
export (String) var combat_name = ""
export (int) var max_hp = 50
export (int) var strength = 10
export (int) var defense = 5
export (int) var intelligence = 2
export (int) var speed = 2
export (int) var current_hp = max_hp

signal defeated

func take_damage(amount: int):
	current_hp -= amount
	if current_hp <= 0:
		emit_signal("defeated")
		
