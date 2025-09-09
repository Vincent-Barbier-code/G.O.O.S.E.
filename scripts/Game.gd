
extends Node2D

var menu_instance: Control = null


func _ready():
	# Create and add the map
	var map_scene = preload("res://scripts/map/Map.gd").new()
	add_child(map_scene)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_toggle_menu()

func _toggle_menu():
	if menu_instance and is_instance_valid(menu_instance):
		menu_instance.queue_free()
		menu_instance = null
	else:
		# Only create menu if none exists
		if menu_instance == null:
			var menu_scene = load("res://scenes/menus/MenuOptions.tscn")
			menu_instance = menu_scene.instantiate()
			add_child(menu_instance)
			menu_instance.z_index = 100 # Ensure menu is on top
			# Connect to know when menu is closed
			menu_instance.tree_exited.connect(_on_menu_closed)

func _on_menu_closed():
	menu_instance = null
