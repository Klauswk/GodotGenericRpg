extends CanvasLayer

class_name StatusMenu

onready var teste = $menuStatus/MarginContainer/VBoxContainer/firstRowContainer

onready var lbPlayerLvl = $menuStatus/MarginContainer/VBoxContainer/firstRowContainer/levelContainer/lbPlayerLevel
onready var lbPlayerXp = $menuStatus/MarginContainer/VBoxContainer/firstRowContainer/xpContainer/lbPlayerXp
onready var lbPlayerBits = $menuStatus/MarginContainer/VBoxContainer/secondRowContainer/bitsContainer/lbPlayerBits
onready var lbPlayerHp = $menuStatus/MarginContainer/VBoxContainer/thirdRowContainer/HBoxContainer2/lbPlayerHp
onready var lbPlayerSpd = $menuStatus/MarginContainer/VBoxContainer/thirdRowContainer/HBoxContainer3/lbPlayerSpd
onready var lbPlayerAtk = $menuStatus/MarginContainer/VBoxContainer/fourthRowContainer/atkContainer/lbPlayerAtk
onready var lbPlayerDef = $menuStatus/MarginContainer/VBoxContainer/fourthRowContainer/defenseContainer/lbPlayerDef
onready var menuStatus = $menuStatus

func _ready():
	menuStatus.hide()
	
func initialize(character: Character ):
	lbPlayerLvl.text = str(character.level)
	lbPlayerBits.text = str(character.bits)
	lbPlayerXp.text = str(character.experience_total,"/",character.experience_required)
	lbPlayerHp.text = str(character.current_hp,"/",character.max_hp)
	lbPlayerAtk.text = str(character.strength)
	lbPlayerDef.text = str(character.defense)
	lbPlayerSpd.text = str(character.speed)

func show_menu():
	menuStatus.show()

func hide_menu():
	menuStatus.hide()

func visible() -> bool:
	return menuStatus.visible
