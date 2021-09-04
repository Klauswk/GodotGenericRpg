extends Control

onready var character_current_hp = $player_gui/vboxInfo/hpContainer/lbCurrentHp
onready var enemy_current_hp = $HBoxContainer/hpContainer/lbCurrentHp
onready var lb_enemy = $HBoxContainer/enemyName

onready var btnAttack = $player_gui/vboxActions/btnAtk
onready var btnItem = $player_gui/vboxActions/btnItem
onready var btnRun = $player_gui/vboxActions/btnRun
onready var ctrlPlayerGui: Control = $player_gui

onready var item_menu = $item_menu

onready var textBox = $textbox

var character: Character
var enemy: Enemy

signal battle_end
signal escape
signal miss_attack(attacker)

func _ready():
	add_to_group("battle_scene")

	btnAttack.grab_focus()
	
	lb_enemy.text = enemy.combat_name
	character_current_hp.text = str(character.current_hp, "/", character.max_hp)
	enemy_current_hp.text = str(enemy.current_hp, "/", enemy.max_hp)
	
	btnAttack.connect("pressed", self, "_on_btn_attack")
	btnItem.connect("pressed", self, "_on_btn_item")
	btnRun.connect("pressed", self, "_on_btn_run")

	item_menu.initialize(character, enemy)
	item_menu.hide_menu()
	
	item_menu.connect("item_use", self, "_on_item_use")
	
func _input(event):
	if (event.is_action_pressed("ui_accept") || event.is_action_pressed("ui_cancel")) && !ctrlPlayerGui.visible:
		textBox.nextText()

func initialize(_character: Character, _enemy: Enemy):
	character = _character
	enemy = _enemy

func _on_player_defeated():
	show_text("You got defeated!")
	yield(textBox, "finished")
	emit_signal("battle_end")
	
func _on_enemy_defeated():
	show_text(str("Gain exp of ", enemy.experience, " and ", enemy.bits, " bits!"))
	yield(textBox, "finished")
	var has_level = character.increase_experience(enemy.experience)
	character.increase_bits(enemy.bits)
	
	if has_level:
		show_text(str("Reach a new level, you are now level ", character.level))
		yield(textBox, "finished")
		
	emit_signal("battle_end")

func _on_btn_item():
	item_menu.show_menu()

func _on_btn_run():
	var chance_to_escape = (randi() % 20) + max(0, character.speed - enemy.speed)
	if chance_to_escape > 20:
		show_text("You successfully escape")
		yield(textBox, "finished")
		emit_signal("escape")
	else:
		var damage = calculate_damage(enemy, character)
		character.take_damage(damage)
		show_text(str("You took ", damage, "while trying to escape"))
		yield(textBox, "finished")
		
	btnRun.grab_focus()

func _on_btn_attack():
	attack()
	
func attack():
	if(character.speed > enemy.speed):
		if !chance_to_miss(character,enemy):
			var damage = calculate_damage(character,enemy)
			enemy.take_damage(damage)
			show_text(str("You deal ", damage))
			yield(textBox, "finished")
		else:
			show_text("You miss!")
			yield(textBox, "finished")
		if enemy.current_hp > 0:
			if !chance_to_miss(enemy,character):
				var damage = calculate_damage(enemy, character)
				character.take_damage(damage)
				show_text(str("You took ", damage))
				yield(textBox, "finished")
			else:
				show_text(str(enemy.combat_name," miss!"))
				yield(textBox, "finished")
	else:
		if !chance_to_miss(enemy,character):
				var damage = calculate_damage(enemy, character)
				character.take_damage(damage)
				show_text(str("You took ", damage))
				yield(textBox, "finished")
		else:
			show_text(str(enemy.combat_name," miss!"))
			yield(textBox, "finished")
			
		if character.current_hp > 0:
			if !chance_to_miss(character,enemy):
				var damage = calculate_damage(character,enemy)
				enemy.take_damage(damage)
				show_text(str("You deal ", damage))
				yield(textBox, "finished")
			else:
				show_text("You miss!")
				yield(textBox, "finished")
		
	character_current_hp.text = str(character.current_hp, "/", character.max_hp)
	enemy_current_hp.text = str(enemy.current_hp, "/", enemy.max_hp)
	
	if character.current_hp <= 0:
		_on_player_defeated()
	elif enemy.current_hp <= 0:
		_on_enemy_defeated()
	else:
		btnAttack.grab_focus()
		
func calculate_damage(attacker: Entity, defender: Entity) -> int:
	return int(max(0, attacker.strength - defender.defense))

func chance_to_miss(attacker: Entity, defender: Entity) -> bool:
	var miss = ((randi() % 20) + max(0, attacker.speed - defender.speed)) < 5

	if miss:
		emit_signal("miss_attack", attacker)

	return miss

func show_text(text):
	ctrlPlayerGui.hide()
	textBox.set_text(text)

func _on_textbox_finished():
	ctrlPlayerGui.show()

func _on_item_use(item: GameItem, text: String):
	item_menu.hide_menu()
	show_text(text)
	yield(textBox, "finished")
	if enemy.current_hp > 0:
		if !chance_to_miss(enemy,character):
			var damage = calculate_damage(enemy, character)
			character.take_damage(damage)
			show_text(str("You took ", damage))
			yield(textBox, "finished")
		else:
			show_text(str(enemy.combat_name," miss!"))
			yield(textBox, "finished")
			
	character_current_hp.text = str(character.current_hp, "/", character.max_hp)
	enemy_current_hp.text = str(enemy.current_hp, "/", enemy.max_hp)
	
	if character.current_hp <= 0:
		_on_player_defeated()
	elif enemy.current_hp <= 0:
		_on_enemy_defeated()
	else:
		btnItem.grab_focus()
