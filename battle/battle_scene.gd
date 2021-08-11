extends Control

onready var hpQuantity = $vboxInfo/HBoxContainer/hpQuantity
onready var mpQuantity = $vboxInfo/HBoxContainer/mpQuantity
onready var enemy = $HBoxContainer/enemyName

func _ready():
	$vboxActions/btnAtk.grab_focus()
	
	enemy.text = "Goblin"
	
	for childs in $vboxActions.get_children():
		if "Button" in childs.get_class():
			var button: Button = childs
			button.connect("pressed", self, "_on_btn_pressed", [button.text])

func _on_btn_pressed(scene_to_load):
	print_debug(scene_to_load)
