extends Control

onready var character_current_hp = $vboxInfo/hpContainer/lbCurrentHp
onready var enemy_current_hp = $HBoxContainer/hpContainer/lbCurrentHp
onready var lb_enemy = $HBoxContainer/enemyName

onready var btnAttack = $vboxActions/btnAtk
onready var btnRun = $vboxActions/btnRun

onready var textBox = $textbox

var character: Character
var enemy: Enemy

signal battle_end
signal escape
signal miss_attack(attacker)

func _ready():
	add_to_group("battle_scene")

	$vboxActions/btnAtk.grab_focus()
	
	lb_enemy.text = enemy.combat_name
	character_current_hp.text = str(character.current_hp, "/", character.max_hp)
	enemy_current_hp.text = str(enemy.current_hp, "/", enemy.max_hp)
	
	enemy.connect("defeated", self, "_on_enemy_defeated")
	character.connect("defeated", self, "_on_player_defeated")
	
	btnAttack.connect("pressed", self, "_on_btn_attack")
	btnRun.connect("pressed", self, "_on_btn_run")
	

func initialize(_character: Character, _enemy: Enemy):
	character = _character
	enemy = _enemy

func _on_player_defeated():
	emit_signal("battle_end")

func _on_enemy_defeated():
	print_debug("Gain exp of ", enemy)
	character.increase_experience(enemy.experience)
	emit_signal("battle_end")

func _on_btn_run():
	var chance_to_escape = (randi() % 20) + max(0, character.speed - enemy.speed)
	if chance_to_escape > 20:
		emit_signal("escape")
	else:
		character.take_damage(calculate_damage(enemy, character))

func _on_btn_attack():
	attack()
	
func attack():
	if(character.speed > enemy.speed):
		if !chance_to_miss(character,enemy):
			enemy.take_damage(calculate_damage(character, enemy))
			if enemy.current_hp > 0:
				if !chance_to_miss(enemy,character):
					character.take_damage(calculate_damage(enemy, character))
	else:
		if !chance_to_miss(enemy,character):
			character.take_damage(calculate_damage(enemy, character))
			if character.current_hp > 0:
				if !chance_to_miss(character,enemy):
					enemy.take_damage(calculate_damage(character, enemy))
		
	character_current_hp.text = str(character.current_hp, "/", character.max_hp)
	enemy_current_hp.text = str(enemy.current_hp, "/", enemy.max_hp)
		
func calculate_damage(attacker: CombatAttribute, defender: CombatAttribute) -> int:
	return int(max(0, attacker.strength - defender.defense))

func chance_to_miss(attacker: CombatAttribute, defender: CombatAttribute) -> bool:
	var miss = ((randi() % 5) + max(0, attacker.speed - defender.speed)) < 5

	if miss:
		emit_signal("miss_attack", attacker)

	return miss
