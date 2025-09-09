extends Panel

# Script pour le menu d'options de partie solo
# Permet de choisir la taille de la carte, la difficulté, etc.

@onready var map_size_spin: SpinBox = $VBoxContainer/MapSizeSpin
@onready var difficulty_option: OptionButton = $VBoxContainer/DifficultyOption
@onready var start_btn: Button = $VBoxContainer/StartButton
@onready var cancel_btn: Button = $VBoxContainer/CancelButton

func _ready():
	# Remplir les options de difficulté
	difficulty_option.add_item("Facile")
	difficulty_option.add_item("Normal")
	difficulty_option.add_item("Difficile")
	# Connexion des boutons
	start_btn.pressed.connect(_on_start_pressed)
	cancel_btn.pressed.connect(_on_cancel_pressed)
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
	# Récupérer les options choisies
	var map_size = int(map_size_spin.value)
	var difficulty = difficulty_option.get_selected_id()
	# TODO : Lancer la partie solo avec ces paramètres
	print("Démarrage partie solo : taille=", map_size, ", difficulté=", difficulty)
	queue_free()

func _on_cancel_pressed():
	queue_free()
