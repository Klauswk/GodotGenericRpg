extends MapAction

class_name ShopNpc

signal open_shop

func interact():
	emit_signal("open_shop")
