extends Node2D


var width = 10  # number of tiles horizontally
var height = 10 # number of tiles vertically
var tile_size = 64 # will be recalculated
var tiles = []
var intersections = []
var player = null


func _ready():
	# Récupère la taille de map choisie dans GameSettings
	# if Engine.has_singleton("GameSettings"):
	print("GameSettings.map_size=", GameSettings.map_size)
	var map_size = GameSettings.map_size
	width = map_size.x
	height = map_size.y
	# else:
	# 	width = 10
	# 	height = 10
	print("width=", width, " height=", height)
	randomize()
	var tile_scene = preload("res://scripts/tiles/Tile.gd")
	var intersection_scene = preload("res://scripts/map/Intersection.gd")
	# Create tiles
	for y in range(height):
		for x in range(width):
			var tile = tile_scene.new()
			tile.grid_x = x
			tile.grid_y = y
			var terrain_classes = [
				preload("res://scripts/tiles/types/Plain.gd"),
				preload("res://scripts/tiles/types/Mountain.gd"),
				preload("res://scripts/tiles/types/Lake.gd"),
				preload("res://scripts/tiles/types/Desert.gd"),
				preload("res://scripts/tiles/types/Forest.gd")
			]
			var terrain_class = terrain_classes[randi() % terrain_classes.size()]
			tile.terrain_type = terrain_class.new()
			tile.tile_type = tile.terrain_type.name
			add_child(tile)
			tiles.append(tile)
	# Create intersections
	for y in range(height-1):
		for x in range(width-1):
			var intersection = intersection_scene.new()
			add_child(intersection)
			intersections.append(intersection)

	# Add player
	player = preload("res://scripts/players/Player.gd").new()
	player.set_map_info(width, height, tile_size, 0, 0) # offset mis à jour juste après
	add_child(player)

	# Place le Store au centre de la map
	var center_x = int(width / 2)
	var center_y = int(height / 2)
	# Recherche et retire la tuile existante au centre
	for tile in tiles:
		if tile.grid_x == center_x and tile.grid_y == center_y:
			tile.queue_free()
			tiles.erase(tile)
			break
	# Ajoute la tuile Store
	var store_tile = preload("res://scripts/tiles/types/Store.gd").new()
	store_tile.grid_x = center_x
	store_tile.grid_y = center_y
	store_tile.terrain_type = store_tile
	store_tile.tile_type = "store"
	add_child(store_tile)
	tiles.append(store_tile)

	_update_tiles_and_intersections()
	get_viewport().size_changed.connect(_update_tiles_and_intersections)

# Update tile size and positions based on window size
func _update_tiles_and_intersections():
	var viewport_size = get_viewport_rect().size
	tile_size = min(viewport_size.x / width, viewport_size.y / height)
	# Center the map
	var offset_x = (viewport_size.x - tile_size * width) / 2
	var offset_y = (viewport_size.y - tile_size * height) / 2
	# Update tiles
	for tile in tiles:
		tile.position = Vector2(tile.grid_x * tile_size + offset_x, tile.grid_y * tile_size + offset_y)
		if tile.has_method("set_tile_size"):
			tile.set_tile_size(tile_size)
	# Update intersections
	for i in range(intersections.size()):
		var x = i % (width-1)
		var y = i / (width-1)
		intersections[i].position = Vector2((x + 1) * tile_size + offset_x, (y + 1) * tile_size + offset_y)
		if intersections[i].has_method("set_intersection_size"):
			intersections[i].set_intersection_size(tile_size * 0.15)  # Smaller but more visible
	# Update player offset
	if player:
		player.set_map_info(width, height, tile_size, offset_x, offset_y)
