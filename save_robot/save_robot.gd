extends MapAction

class_name SaveNpc

var location
var player

func initialize(location: String, player: Player):
	self.location = location
	self.player = player

func interact():
	save_game()
	emit_signal("text_show", "Saving the game")

func save_game():
	var save_game = File.new()
	save_game.open("user://DW2023.save", File.WRITE)
	
	var item_list = []
	
	for item in player.character.items:
		item_list.append({"item_id": item.id, "quantity": item.quantity})
	
	var save_dict = {
		"location": location,
		"position_x": player.position.x,
		"position_y": player.position.y,
		"level": player.character.level,
		"max_hp": player.character.max_hp,
		"strength": player.character.strength,
		"defense": player.character.defense,
		"intelligence": player.character.intelligence,
		"speed" :player.character.speed,
		"current_hp": player.character.current_hp,
		"experience_total": player.character.experience_total,
		"items": item_list,
		"open_chests": player.character.open_chests
	}
	
	save_game.store_line(to_json(save_dict))
	save_game.close()
