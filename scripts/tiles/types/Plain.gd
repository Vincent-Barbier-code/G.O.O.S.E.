extends TileType
class_name Plain

func _init():
	name = "plain"
	color = Color(0.6, 0.9, 0.5)
	resource_weights = {
		"food": 4,
		"energy": 2,
		"metal": 1,
		"coal": 1
	}

func get_color():
	return Color(0.2, 0.8, 0.2) # Vert pour la plaine