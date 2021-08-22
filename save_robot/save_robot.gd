extends MapAction

class_name SaveNpc

func interact():
	emit_signal("text_show", str("Saving the game"))
