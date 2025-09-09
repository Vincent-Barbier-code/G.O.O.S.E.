extends Control
var modal_bg: ColorRect = null

# Simple main menu script for Godot
var options_panel: Panel = null
var options_modal_bg: ColorRect = null
var confirmation_panel: Panel = null
var confirmation_timer: Timer = null
var previous_resolution: Vector2i
var confirmation_label: Label = null

func _ready():
	# Make this Control cover the entire screen and block all input
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Add a modal background to block input
	modal_bg = ColorRect.new()
	modal_bg.color = Color(0, 0, 0, 0.4)
	modal_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	modal_bg.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(modal_bg)

	# Create the actual menu panel
	var menu_panel = Panel.new()
	menu_panel.size = Vector2(400, 300)
	add_child(menu_panel)
	
	call_deferred("_center_menu_panel")
	call_deferred("_add_menu_elements")
	get_viewport().size_changed.connect(_on_viewport_resize)

	# Rendre le focus clavier possible sur tous les boutons
	var panel_ref = get_child(1) # Le panel est le second enfant après modal_bg
	if panel_ref:
		for btn in panel_ref.get_children():
			if btn is Button:
				btn.focus_mode = Control.FOCUS_ALL
		# Donner le focus au premier bouton
		if panel_ref.get_child_count() > 0:
			panel_ref.get_child(0).grab_focus()

func _center_menu_panel():
	var menu_panel = get_child(1) # The panel is the second child after modal_bg
	if menu_panel:
		var viewport_size = get_viewport_rect().size
		menu_panel.position = (viewport_size - menu_panel.size) * 0.5

func _on_viewport_resize():
	_center_menu_panel()
	if modal_bg:
		modal_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if options_modal_bg:
		options_modal_bg.size = get_viewport_rect().size
		_center_options_panel()

func _input(event):
	# Allow Escape key to close the menu
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		return  # Let the escape key pass through
	
	# Don't block mouse events - let the UI handle them normally
	# The modal background will block clicks outside the menu
	if event is InputEventKey:
		get_viewport().set_input_as_handled()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:
			_on_close_options()
		elif event.keycode == KEY_ENTER and event.pressed:
			var focus = get_viewport().gui_get_focus_owner()
			if focus is Button:
				focus.emit_signal("pressed")

func _add_menu_elements():
	var menu_panel = get_child(1) # The panel is the second child after modal_bg
	if not menu_panel:
		return
		
	# Create title label
	var title = Label.new()
	title.text = "G.O.O.S.E."
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.size_flags_vertical = Control.SIZE_EXPAND_FILL
	title.custom_minimum_size = Vector2(400, 60)
	title.add_theme_color_override("font_color", Color(1,1,0))
	menu_panel.add_child(title)

	# Create Play button
	var play_btn = Button.new()
	play_btn.text = "Play"
	play_btn.custom_minimum_size = Vector2(200, 40)
	play_btn.position = Vector2(100, 80)
	play_btn.pressed.connect(_on_play_pressed)
	menu_panel.add_child(play_btn)

	# Create Options button
	var options_btn = Button.new()
	options_btn.text = "Options"
	options_btn.custom_minimum_size = Vector2(200, 40)
	options_btn.position = Vector2(100, 130)
	options_btn.pressed.connect(_on_options_pressed)
	menu_panel.add_child(options_btn)

	# Create Quit button
	var quit_btn = Button.new()
	quit_btn.text = "Quit"
	quit_btn.custom_minimum_size = Vector2(200, 40)
	quit_btn.position = Vector2(100, 180)
	quit_btn.pressed.connect(_on_quit_pressed)
	menu_panel.add_child(quit_btn)


func _on_options_pressed():
	if options_panel and options_panel.visible:
		return

	# Create full screen modal background (blocks all input)
	options_modal_bg = ColorRect.new()
	options_modal_bg.color = Color(0, 0, 0, 0.7)
	options_modal_bg.size = get_viewport_rect().size
	options_modal_bg.position = Vector2.ZERO
	options_modal_bg.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(options_modal_bg)
	options_modal_bg.move_to_front()

	# Create and center the options panel as child of the modal
	options_panel = Panel.new()
	options_panel.size = Vector2(320, 260)
	options_modal_bg.add_child(options_panel)
	_center_options_panel()

	var label = Label.new()
	label.text = "Select Resolution:"
	label.position = Vector2(20, 20)
	options_panel.add_child(label)

	var resolutions = [
		{"label": "1280x720", "size": Vector2i(1280, 720)},
		{"label": "1600x900", "size": Vector2i(1600, 900)},
		{"label": "1920x1080", "size": Vector2i(1920, 1080)},
		{"label": "2560x1440", "size": Vector2i(2560, 1440)}
	]

	for i in range(resolutions.size()):
		var res_btn = Button.new()
		res_btn.text = resolutions[i]["label"]
		res_btn.position = Vector2(20, 60 + i * 40)
		res_btn.custom_minimum_size = Vector2(180, 32)
		res_btn.pressed.connect(_on_resolution_selected.bind(resolutions[i]["size"]))
		options_panel.add_child(res_btn)

	var close_btn = Button.new()
	close_btn.text = "Close"
	close_btn.position = Vector2(220, 170)
	close_btn.custom_minimum_size = Vector2(80, 32)
	close_btn.pressed.connect(_on_close_options)
	options_panel.add_child(close_btn)

func _on_resolution_selected(resolution: Vector2i):
	var current_resolution = DisplayServer.window_get_size()
	
	# Don't show confirmation if the resolution is the same
	if current_resolution == resolution:
		print("Resolution is already set to: ", resolution)
		return
	
	previous_resolution = current_resolution
	DisplayServer.window_set_size(resolution)
	_center_menu_panel()  # Recenter menu after resolution change
	_show_confirmation_dialog()


func _show_confirmation_dialog():
	if confirmation_panel:
		return

	# Create confirmation modal
	var conf_modal_bg = ColorRect.new()
	conf_modal_bg.color = Color(0, 0, 0, 0.8)
	conf_modal_bg.size = get_viewport_rect().size
	conf_modal_bg.position = Vector2.ZERO
	conf_modal_bg.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(conf_modal_bg)
	conf_modal_bg.move_to_front()

	confirmation_panel = Panel.new()
	confirmation_panel.size = Vector2(300, 120)
	var center_pos = (get_viewport_rect().size - confirmation_panel.size) * 0.5
	confirmation_panel.position = center_pos
	add_child(confirmation_panel)
	confirmation_panel.move_to_front()

	confirmation_label = Label.new()
	confirmation_label.text = "Keep this resolution? (15)"
	confirmation_label.position = Vector2(20, 20)
	confirmation_label.size = Vector2(260, 20)
	confirmation_panel.add_child(confirmation_label)

	var keep_btn = Button.new()
	keep_btn.text = "Keep"
	keep_btn.position = Vector2(50, 60)
	keep_btn.size = Vector2(80, 30)
	keep_btn.pressed.connect(_keep_resolution.bind(conf_modal_bg))
	confirmation_panel.add_child(keep_btn)

	var revert_btn = Button.new()
	revert_btn.text = "Revert"
	revert_btn.position = Vector2(170, 60)
	revert_btn.size = Vector2(80, 30)
	revert_btn.pressed.connect(_revert_resolution.bind(conf_modal_bg))
	confirmation_panel.add_child(revert_btn)

	# Start countdown timer
	confirmation_timer = Timer.new()
	confirmation_timer.wait_time = 1.0
	confirmation_timer.timeout.connect(_countdown_tick.bind(conf_modal_bg))
	add_child(confirmation_timer)
	confirmation_timer.start()

var countdown_seconds = 15

func _countdown_tick(conf_modal_bg):
	countdown_seconds -= 1
	if confirmation_label:
		confirmation_label.text = "Keep this resolution? (" + str(countdown_seconds) + ")"
	
	if countdown_seconds <= 0:
		_revert_resolution(conf_modal_bg)

func _keep_resolution(conf_modal_bg):
	_cleanup_confirmation(conf_modal_bg)

func _revert_resolution(conf_modal_bg):
	DisplayServer.window_set_size(previous_resolution)
	_center_menu_panel()
	_cleanup_confirmation(conf_modal_bg)

func _cleanup_confirmation(conf_modal_bg):
	if confirmation_timer:
		confirmation_timer.stop()
		confirmation_timer.queue_free()
		confirmation_timer = null
	if confirmation_panel:
		confirmation_panel.queue_free()
		confirmation_panel = null
	conf_modal_bg.queue_free()
	confirmation_label = null
	countdown_seconds = 15

func _on_close_options():
	if options_panel:
		options_panel.queue_free()
		options_panel = null
	if options_modal_bg:
		options_modal_bg.queue_free()
		options_modal_bg = null

func _center_options_panel():
	if options_panel and options_modal_bg:
		var center_pos = (get_viewport_rect().size - options_panel.size) * 0.5
		options_panel.position = center_pos


func _on_play_pressed():
	# Close the menu and return to game
	queue_free()

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/StartMenu.tscn")
