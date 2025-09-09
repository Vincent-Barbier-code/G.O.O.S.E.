extends Control

# Script du menu principal (Start Menu) pour G.O.O.S.E.
# Affiche les boutons : Solo, Multijoueur, Options, Quitter
# Gère les interactions de base du menu principal

@onready var solo_btn: Button = $VBoxContainer/SoloButton
@onready var multi_btn: Button = $VBoxContainer/MultiButton
@onready var options_btn: Button = $VBoxContainer/OptionsButton
@onready var quit_btn: Button = $VBoxContainer/QuitButton

func _ready():
	_center_menu()
	# Connexion des signaux
	solo_btn.pressed.connect(_on_solo_pressed)
	multi_btn.pressed.connect(_on_multi_pressed)
	options_btn.pressed.connect(_on_options_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)
	# Rendre le focus clavier possible sur tous les boutons
	for btn in $VBoxContainer.get_children():
		if btn is Button:
			btn.focus_mode = Control.FOCUS_ALL
	# Donner le focus au premier bouton
	if $VBoxContainer.get_child_count() > 0:
		$VBoxContainer.get_child(0).grab_focus()

func _center_menu():
	# Centre le menu dans la fenêtre
	var viewport_size = get_viewport_rect().size
	var menu_size = size
	if $VBoxContainer:
		menu_size = $VBoxContainer.size
	position = (viewport_size - menu_size) * 0.5

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_center_menu()

func _on_solo_pressed():
	# Change complètement de scène pour GameParameters (remplace StartMenu)
	get_tree().change_scene_to_file("res://scenes/menus/GameParameters.tscn")

func _start_game(map_size, difficulty):
	# Ici tu pourras lancer la partie avec les paramètres reçus
	get_tree().change_scene_to_file("res://scenes/game/Game.tscn")

func _on_multi_pressed():
	# TODO : Afficher le menu multijoueur
	print("Menu multijoueur")

func _on_options_pressed():
	# TODO : Afficher le menu des options
	print("Menu options")

func _on_quit_pressed():
	get_tree().quit()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:
			get_tree().quit()
		elif event.keycode == KEY_ENTER and event.pressed:
			var focus = get_viewport().gui_get_focus_owner()
			if focus is Button:
				focus.emit_signal("pressed")
