extends Panel

# GameParameters.gd : Menu pour paramétrer la partie solo
# Permet de choisir la taille de la carte, la difficulté, etc.

signal start_game(map_size)

@onready var map_size_option: OptionButton = $VBoxContainer/MapSizeOption
@onready var turn_count_option: OptionButton = $VBoxContainer/TurnCountOption
@onready var start_btn: Button = $VBoxContainer/StartButton
@onready var cancel_btn: Button = $VBoxContainer/CancelButton

func _ready():
	# Centre le panneau GameParameters dans la fenêtre
	var viewport_size = get_viewport_rect().size
	size = Vector2(360, 220)
	position = (viewport_size - size) * 0.5

	start_btn.pressed.connect(_on_start_pressed)
	cancel_btn.pressed.connect(_on_cancel_pressed)
	# Remplir la liste des tailles de carte
	map_size_option.clear()
	map_size_option.add_item("9 x 5")
	map_size_option.set_item_metadata(0, Vector2i(9, 5))
	map_size_option.add_item("11 x 7")
	map_size_option.set_item_metadata(1, Vector2i(11, 7))
	map_size_option.add_item("11 x 9")
	map_size_option.set_item_metadata(2, Vector2i(11, 9))
	# Remplir la liste des nombres de tours
	turn_count_option.clear()
	turn_count_option.add_item("12 turns", 12)
	turn_count_option.add_item("16 turns", 16)
	turn_count_option.add_item("24 turns", 24)
	# Rendre le focus clavier possible sur tous les boutons
	for btn in $VBoxContainer.get_children():
		if btn is Button:
			btn.focus_mode = Control.FOCUS_ALL
	# Donner le focus au premier bouton
	if $VBoxContainer.get_child_count() > 0:
		$VBoxContainer.get_child(0).grab_focus()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:
			get_tree().change_scene_to_file("res://scenes/menus/StartMenu.tscn")
		elif event.keycode == KEY_ENTER and event.pressed:
			var focus = get_viewport().gui_get_focus_owner()
			if focus is Button:
				focus.emit_signal("pressed")

func _on_start_pressed():
	var map_size = map_size_option.get_selected_metadata()
	var turn_count = turn_count_option.get_selected_metadata()
	GameSettings.map_size = map_size
	GameSettings.turn_count = turn_count
	emit_signal("start_game", map_size)
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_cancel_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/StartMenu.tscn")
