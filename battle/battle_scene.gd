extends Control

onready var character_current_hp = $vboxInfo/hpContainer/lbCurrentHp
onready var enemy_current_hp = $HBoxContainer/hpContainer/lbCurrentHp
onready var lb_enemy = $HBoxContainer/enemyName

var character: Character
var enemy: Enemy

signal battle_end

func _ready():
	$vboxActions/btnAtk.grab_focus()
	
	lb_enemy.text = enemy.combat_name
	character_current_hp.text = str(character.current_hp, "/", character.max_hp)
	enemy_current_hp.text = str(enemy.current_hp, "/", enemy.max_hp)
	
	enemy.connect("defeated", self, "battle_ended")
	character.connect("defeated", self, "battle_ended")
	
	for childs in $vboxActions.get_children():
		if "Button" in childs.get_class():
			var button: Button = childs
			button.connect("pressed", self, "_on_btn_pressed", [button.text])

func initialize(_character: Character, _enemy: Enemy):
	character = _character
	enemy = _enemy

func battle_ended():
	emit_signal("battle_end")

func _on_btn_pressed(scene_to_load):
	print_debug("entra aqui")
	if "Run" in scene_to_load:
		emit_signal("battle_end")
	elif "Attack" in scene_to_load:
		attack()
	
func attack():
	if(character.speed > enemy.speed):
		enemy.take_damage(5)
		if !(enemy.current_hp <= 0):
			character.take_damage(5)
	else:
		character.take_damage(5)
		if !(character.current_hp <= 0):
			enemy.take_damage(5)
		
	character_current_hp.text = str(character.current_hp, "/", character.max_hp)
	enemy_current_hp.text = str(enemy.current_hp, "/", enemy.max_hp)
		
