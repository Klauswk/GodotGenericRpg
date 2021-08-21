extends CanvasLayer

class_name GameTextBox

onready var tbContainer = $Container
onready var lbText = $Container/MarginContainer/HBoxContainer/Label
onready var lbPlus = $Container/MarginContainer/HBoxContainer/plus

var text_list: Array

const MAX_TEXT_SIZE = 66

signal finished

func _ready():
	tbContainer.hide()

func set_text(text: String):
	var init_count = 0
	var end_count = text.length()
	
	if end_count < MAX_TEXT_SIZE:
		text_list.push_front(text)
	else:
		while init_count < MAX_TEXT_SIZE:
			text_list.push_front(text.substr(init_count, MAX_TEXT_SIZE))
			init_count += MAX_TEXT_SIZE
		text_list.push_front(text.substr(init_count))
	
	tbContainer.show()
	
func _process(delta):
	
	if tbContainer.visible && Input.is_action_just_pressed("ui_accept"):
		if text_list.size() > 0:
			show_textbox(text_list.pop_front())
		else:
			hide_textbox()
			emit_signal("finished")

func hide_textbox():
	lbText.text = ""
	lbPlus.text = ""
	tbContainer.hide()

func show_textbox(text: String):
	lbText.text = text
	if text_list.size() > 0:
		lbPlus.text = "+"
	else:
		lbPlus.text = ""
	tbContainer.show()
	
