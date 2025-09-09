extends TileType
class_name Lake

func _init():
	name = "lake"
	color = Color(0.3, 0.5, 1)
	resource_weights = {
		"food": 3,
		"energy": 4
	}

func get_color():
	return Color(0, 0, 1) # Bleu pour lac