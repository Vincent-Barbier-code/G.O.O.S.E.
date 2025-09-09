extends Tile
class_name Store

# Store.gd : tuile spéciale centrale, sans ressource, ouvre une scène intérieure

func _init():
	tile_type = "store"
	terrain_type = self

func get_display_name():
	return "Store"

func get_color():
	return Color(1, 0.2, 0) # Orange-rouge vif pour le Store

func on_player_enter():
	get_tree().change_scene_to_file("res://scenes/StoreInterior.tscn")
