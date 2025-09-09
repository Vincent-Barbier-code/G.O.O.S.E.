extends Node2D

# Player position in grid coordinates
var grid_x = 0
var grid_y = 0

# Reference to the map for bounds (to be set by parent)
var map_width := 10
var map_height := 10
var tile_size := 64
var tween: Tween = null

var move_dir := Vector2.ZERO
var move_timer: Timer = null
var move_delay := 0.35 # Augmente la valeur pour ralentir le déplacement

var map_offset_x := 0.0
var map_offset_y := 0.0

func _ready():
	# Draw a small colored circle to represent the player
	var dot = ColorRect.new()
	dot.color = Color(1, 0.2, 0.2)
	dot.size = Vector2(tile_size * 0.4, tile_size * 0.4)
	dot.position = Vector2(-dot.size.x/2, -dot.size.y/2)
	add_child(dot)
	# Always start at (0,0) and clamp to map
	grid_x = clamp(grid_x, 0, map_width-1)
	grid_y = clamp(grid_y, 0, map_height-1)
	_update_position(true)

func set_map_info(width, height, tsize, offset_x=0.0, offset_y=0.0):
	map_width = width
	map_height = height
	tile_size = tsize
	map_offset_x = offset_x
	map_offset_y = offset_y
	_update_position(true)

func update_map_offset(offset_x, offset_y):
	map_offset_x = offset_x
	map_offset_y = offset_y
	_update_position()

func _update_position(immediate=false):
	var target_pos = Vector2(grid_x * tile_size + tile_size * 0.5 + map_offset_x, grid_y * tile_size + tile_size * 0.5 + map_offset_y)
	if immediate:
		position = target_pos
		return
	if tween:
		tween.kill()
		tween = null
	tween = create_tween()
	tween.tween_property(self, "position", target_pos, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_UP or event.keycode == KEY_W:
				move_dir = Vector2(0, -1)
				_start_move_repeat()
			elif event.keycode == KEY_DOWN or event.keycode == KEY_S:
				move_dir = Vector2(0, 1)
				_start_move_repeat()
			elif event.keycode == KEY_LEFT or event.keycode == KEY_A:
				move_dir = Vector2(-1, 0)
				_start_move_repeat()
			elif event.keycode == KEY_RIGHT or event.keycode == KEY_D:
				move_dir = Vector2(1, 0)
				_start_move_repeat()
		if not event.pressed:
			move_dir = Vector2.ZERO
			_stop_move_repeat()

func _start_move_repeat():
	_move_once()
	if move_timer:
		move_timer.stop()
		move_timer.queue_free()
	move_timer = Timer.new()
	move_timer.wait_time = move_delay
	move_timer.one_shot = false
	move_timer.timeout.connect(_move_once)
	add_child(move_timer)
	move_timer.start()

func _stop_move_repeat():
	if move_timer:
		move_timer.stop()
		move_timer.queue_free()
		move_timer = null

func _move_once():
	var nx = grid_x + int(move_dir.x)
	var ny = grid_y + int(move_dir.y)
	if nx >= 0 and nx < map_width and ny >= 0 and ny < map_height:
		grid_x = nx
		grid_y = ny
		_update_position()
		# Appeler la méthode on_player_enter() sur la tuile courante si elle existe
		if get_parent().has_method("get_tile_at"):
			var tile = get_parent().get_tile_at(grid_x, grid_y)
			if tile and tile.has_method("on_player_enter"):
				tile.on_player_enter()
