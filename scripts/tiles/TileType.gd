extends Resource
class_name TileType

var name = ""
var color = Color(0.5,0.5,0.5)
var resource_weights = {}

func get_random_resource():
	var pool = []
	for res in resource_weights.keys():
		for i in range(resource_weights[res]):
			pool.append(res)
	if pool.size() > 0:
		return pool[randi() % pool.size()]
	return "empty"