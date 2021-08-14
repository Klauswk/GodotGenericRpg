extends Control

signal battle_end

func _ready():
	$Menu/CenterRow/VBoxContainer/btnNewGame.grab_focus()
	
	for button in $Menu/CenterRow/VBoxContainer.get_children():
		button.connect("pressed", self, "_on_btn_pressed")

func _on_btn_pressed(scene_to_load):
	print_debug(scene_to_load)
	emit_signal("battle_end")
