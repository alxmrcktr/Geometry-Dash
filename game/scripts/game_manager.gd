extends Node

var game_active = false
var is_paused = false

@onready var pause_menu: CanvasLayer = null

func _ready():
	# Check if player has already started once - skip menu
	if Globals and Globals.has_started_once:
		# Skip menu, start immediately
		game_active = true
		call_deferred("_start_player")
	else:
		# Show main menu with level selection
		var main_menu = preload("res://scenes/main_menu.tscn")
		var menu = main_menu.instantiate()
		menu.level_selected.connect(_on_level_selected)
		add_child(menu)

func _start_player():
	var player = get_node_or_null("Player")
	if player and player.has_method("start_game"):
		player.start_game()

func _on_level_selected(level_id: int):
	if Globals:
		Globals.has_started_once = true
		Globals.current_level = level_id  # Save which level is selected
	
	# Load the appropriate level
	var level_scene_path = ""
	var music_track = ""
	
	match level_id:
		1:
			level_scene_path = "res://scenes/level_1.tscn"
			music_track = "track1.mp3"
		2:
			level_scene_path = "res://scenes/level_2.tscn"
			music_track = "track2.mp3"
		_:
			# Default to level 1
			level_scene_path = "res://scenes/level_1.tscn"
			music_track = "track1.mp3"
	
	# Load the new level scene
	if level_scene_path != "":
		get_tree().change_scene_to_file(level_scene_path)
		# Start music
		if AudioManager:
			AudioManager.call_deferred("play_music", music_track)

func _input(event):
	# ESC to pause/unpause
	if event.is_action_pressed("ui_cancel"):
		if game_active:
			toggle_pause()
		return
	
	if not game_active or is_paused:
		return
	if event.is_action_pressed("restart"):
		if Globals:
			Globals.attempts += 1
		get_tree().reload_current_scene()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	
	if is_paused:
		show_pause_menu()
	else:
		hide_pause_menu()

func show_pause_menu():
	if pause_menu:
		return
	
	pause_menu = CanvasLayer.new()
	pause_menu.layer = 100
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Dark overlay - use Control for proper anchoring
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0.02, 0.08, 0.85)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.set_anchor(SIDE_RIGHT, 1.0)
	overlay.set_anchor(SIDE_BOTTOM, 1.0)
	overlay.grow_horizontal = Control.GROW_DIRECTION_BOTH
	overlay.grow_vertical = Control.GROW_DIRECTION_BOTH
	pause_menu.add_child(overlay)
	
	# Center container - properly anchored to fill screen
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.set_anchor(SIDE_RIGHT, 1.0)
	center.set_anchor(SIDE_BOTTOM, 1.0)
	center.grow_horizontal = Control.GROW_DIRECTION_BOTH
	center.grow_vertical = Control.GROW_DIRECTION_BOTH
	pause_menu.add_child(center)
	
	# VBox for content
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 25)
	center.add_child(vbox)
	
	# Paused title
	var title = Label.new()
	title.text = "PAUSED"
	title.add_theme_font_size_override("font_size", 64)
	title.add_theme_color_override("font_color", Color(1, 0.8, 0.2, 1))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	# Resume button
	var resume_btn = Button.new()
	resume_btn.text = "▶ RESUME"
	resume_btn.custom_minimum_size = Vector2(220, 55)
	resume_btn.add_theme_font_size_override("font_size", 24)
	resume_btn.pressed.connect(toggle_pause)
	resume_btn.process_mode = Node.PROCESS_MODE_ALWAYS
	resume_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(resume_btn)
	
	# Restart button
	var restart_btn = Button.new()
	restart_btn.text = "↻ RESTART"
	restart_btn.custom_minimum_size = Vector2(220, 55)
	restart_btn.add_theme_font_size_override("font_size", 24)
	restart_btn.pressed.connect(_on_restart_pressed)
	restart_btn.process_mode = Node.PROCESS_MODE_ALWAYS
	restart_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(restart_btn)
	
	# Main menu button
	var menu_btn = Button.new()
	menu_btn.text = "⌂ MAIN MENU"
	menu_btn.custom_minimum_size = Vector2(220, 55)
	menu_btn.add_theme_font_size_override("font_size", 24)
	menu_btn.pressed.connect(_on_main_menu_pressed)
	menu_btn.process_mode = Node.PROCESS_MODE_ALWAYS
	menu_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(menu_btn)
	
	# Hint
	var hint = Label.new()
	hint.text = "Press ESC to Resume"
	hint.add_theme_font_size_override("font_size", 16)
	hint.add_theme_color_override("font_color", Color(0.5, 0.5, 0.6, 1))
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(hint)
	
	add_child(pause_menu)
	resume_btn.grab_focus()

func hide_pause_menu():
	if pause_menu:
		pause_menu.queue_free()
		pause_menu = null

func _on_restart_pressed():
	is_paused = false
	get_tree().paused = false
	if Globals:
		Globals.attempts += 1
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	is_paused = false
	get_tree().paused = false
	if Globals:
		Globals.has_started_once = false  # Reset so menu shows again
	get_tree().reload_current_scene()
