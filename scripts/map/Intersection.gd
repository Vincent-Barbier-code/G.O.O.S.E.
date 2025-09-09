extends Node2D
class_name Intersection

func set_intersection_size(new_size):
	size = new_size
	# Remove all ColorRect children (to avoid stacking)
	for child in get_children():
		if child is ColorRect:
			remove_child(child)
			child.queue_free()
	# Redraw the intersection with better visibility
	var rect = ColorRect.new()
	rect.color = Color(1, 1, 0, 0.8)  # Yellow, more visible
	rect.size = Vector2(size, size)
	rect.position = Vector2(-size * 0.5, -size * 0.5)
	add_child(rect)
	
	# Add a border for better visibility
	var border = ColorRect.new()
	border.color = Color(0, 0, 0, 1)  # Black border
	border.size = Vector2(size + 2, size + 2)
	border.position = Vector2(-size * 0.5 - 1, -size * 0.5 - 1)
	add_child(border)
	border.move_to_front()
	rect.move_to_front()

var size = 16

# Gestion du bâtiment

var building = null # Instance de PetitBatiment

func build(building_type):
	if building != null:
		print("Un bâtiment existe déjà sur cette intersection.")
		return
	var FacilityClass = preload("res://scripts/structures/Facility.gd")
	building = FacilityClass.new(building_type)
	add_child(building)
	print("Bâtiment construit:", building_type, "sur l'intersection")

func _ready():
	# Don't create the visual here - wait for set_intersection_size to be called
	# This avoids conflicts with the dynamic sizing from the map
	pass
