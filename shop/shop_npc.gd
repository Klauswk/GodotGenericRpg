extends MapAction

class_name ShopNpc

signal open_shop

func interact():
	print_debug("Emitindo o sinal para abrir")
	emit_signal("open_shop")
