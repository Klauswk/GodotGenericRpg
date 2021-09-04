extends OpenChestAction

class_name Chest

func interact():
	emit_signal("item_acquired", self.id, self.item_id, self.quantity)
	emit_signal("text_show", str("Just got an ", ItemService.find_by_id(self.id).item_name))
	queue_free()
	
