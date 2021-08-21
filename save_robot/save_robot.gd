extends MapAction

class_name SaveNpc

onready var area2D = $Area2D

func _ready():
	area2D.connect("body_entered", self, "_on_body_enter")
	area2D.connect("body_exited", self, "_on_body_exited")

func _on_body_enter(body):
	if body is Player:
		body.interable(self)

func _on_body_exited(body):
	if body is Player:
		body.interable(null)

func interact():
	emit_signal("text_show", str("Saving the game"))