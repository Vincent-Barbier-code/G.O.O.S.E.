extends TileType
class_name Forest

func _init():
	name = "forest"
	color = Color(0.2, 0.6, 0.2)
	resource_weights = {
		"food": 3,
		"energy": 2,
		"metal": 1,
		"coal": 1
	}

func get_color():
	return Color(0, 1, 0) # Vert pour forêt
