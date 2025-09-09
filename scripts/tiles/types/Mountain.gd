extends TileType
class_name Mountain

func _init():
	name = "mountain"
	color = Color(0.5, 0.5, 0.5)
	resource_weights = {
		"food": 1,
		"energy": 1,
		"metal": 3,
		"diamond": 2,
		"coal": 3
	}

func get_color():
	return Color(0.4, 0.26, 0.13) # Marron pour montagne