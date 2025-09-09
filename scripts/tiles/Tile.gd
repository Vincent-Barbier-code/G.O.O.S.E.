extends Node2D
class_name Tile

func set_tile_size(new_size):
	tile_size = new_size
	# Remove all ColorRect children (to avoid stacking)
	for child in get_children():
		if child is ColorRect:
			remove_child(child)
			child.queue_free()
	# Redraw the tile
	var rect = ColorRect.new()
	rect.size = Vector2(tile_size, tile_size)
	if typeof(terrain_type) == TYPE_OBJECT and terrain_type.has_method("get_color"):
		rect.color = terrain_type.get_color()
	else:
		rect.color = Color(0.5, 0.5, 0.5)
	add_child(rect)
	# Redraw borders
	var border_width = max(1, tile_size * 0.02)
	# Top border
	var border1 = ColorRect.new()
	border1.color = Color(0,0,0)
	border1.size = Vector2(tile_size, border_width)
	add_child(border1)
	# Left border
	var border2 = ColorRect.new()
	border2.color = Color(0,0,0)
	border2.size = Vector2(border_width, tile_size)
	add_child(border2)
	# Bottom border
	var border3 = ColorRect.new()
	border3.color = Color(0,0,0)
	border3.size = Vector2(tile_size, border_width)
	border3.position = Vector2(0, tile_size - border_width)
	add_child(border3)
	# Right border
	var border4 = ColorRect.new()
	border4.color = Color(0,0,0)
	border4.size = Vector2(border_width, tile_size)
	border4.position = Vector2(tile_size - border_width, 0)
	add_child(border4)


var grid_x = 0
var grid_y = 0
var tile_type = "empty"
var terrain_type = "plaine" # 
var tile_size = 64

# Gestion du bâtiment

var building = null # Instance de GrandBatiment

var tile_owner = null # Propriétaire de la tuile

func build(building_type, player=null):
	if building != null:
		print("A building already exists on this tile.")
		return
	if player != null and tile_owner != null and player != tile_owner:
		print("You can only build on your own tiles!")
		return
	var BuildingClass = preload("res://scripts/structures/Building.gd")
	building = BuildingClass.new(building_type)
	add_child(building)
	print("Building constructed:", building_type, "on tile", grid_x, grid_y)


func _ready():
	# Affiche la couleur du terrain (objet TileType)
	var rect = ColorRect.new()
	rect.size = Vector2(tile_size, tile_size)
	if typeof(terrain_type) == TYPE_OBJECT and terrain_type.has_method("get_color"):
		rect.color = terrain_type.get_color()
	else:
		rect.color = Color(0.5, 0.5, 0.5)
	add_child(rect)

	# Bordure noire
	var border = ColorRect.new()
	border.color = Color(0,0,0)
	border.size = Vector2(tile_size, 2)
	add_child(border)
	var border2 = ColorRect.new()
	border2.color = Color(0,0,0)
	border2.size = Vector2(2, tile_size)
	add_child(border2)
	var border3 = ColorRect.new()
	border3.color = Color(0,0,0)
	border3.size = Vector2(tile_size, 2)
	border3.position = Vector2(0, tile_size-2)
	add_child(border3)
	var border4 = ColorRect.new()
	border4.color = Color(0,0,0)
	border4.size = Vector2(2, tile_size)
	border4.position = Vector2(tile_size-2, 0)
	add_child(border4)

	if tile_type != "empty":
		var icon = ColorRect.new()
		icon.size = Vector2(tile_size*0.4, tile_size*0.4)
		icon.position = Vector2(tile_size*0.3, tile_size*0.3)
		if typeof(terrain_type) == TYPE_OBJECT and terrain_type.has_method("get_color"):
			icon.color = terrain_type.get_color()
		else:
			icon.color = Color(1,1,0)
		# add_child(icon)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_global_mouse_position()
		var rect = Rect2(global_position, Vector2(tile_size, tile_size))
		if rect.has_point(mouse_pos):
			print("Tile click: tile_type=", terrain_type.name, ", position=(", grid_x, ",", grid_y, ")")
