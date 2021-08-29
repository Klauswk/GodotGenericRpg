extends CanvasLayer

class_name GameMenu

onready var vboxMenu: VBoxContainer = $vboxMenu
onready var btnStatus: Button = $vboxMenu/btnStatus
onready var btnItems: Button = $vboxMenu/btnItems
onready var btnExit: Button = $vboxMenu/btnExit

signal open
signal close

signal open_status

func _ready():
	vboxMenu.hide()
	
	btnStatus.connect("pressed", self, "_on_btn_status")
	btnExit.connect("pressed", self, "_on_btn_exit")
	
func show_menu():
	emit_signal("open")
	btnStatus.grab_focus()
	vboxMenu.show()

func hide_menu():
	vboxMenu.hide()

func visible() -> bool:
	return vboxMenu.visible

func _on_btn_status():
	emit_signal("open_status")

func _on_btn_exit():
	vboxMenu.hide()
	emit_signal("close")
