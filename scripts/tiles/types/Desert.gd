extends TileType
class_name Desert

func _init():
	name = "desert"
	color = Color(0.95, 0.85, 0.5)
	resource_weights = {
		"energy": 3,
		"metal": 2,
		"diamond": 1,
		"coal": 2
	}

func get_color():
	return Color(1, 1, 0) # Jaune pour désert
