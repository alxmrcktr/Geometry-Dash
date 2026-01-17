extends CanvasLayer

signal game_started

@onready var title_label = $CenterContainer/VBoxContainer/Title
@onready var play_btn = $CenterContainer/VBoxContainer/PlayButton
@onready var attempts_label = $CenterContainer/VBoxContainer/AttemptsLabel
@onready var level_name = $CenterContainer/VBoxContainer/LevelName
@onready var container = $CenterContainer/VBoxContainer
@onready var bg_overlay = $BGOverlay

var is_visible_menu = true

func _ready():
	# Setup initial state
	update_attempts_display()
	play_intro_animation()
	# Focus the play button so it can be clicked
	play_btn.grab_focus()

func play_intro_animation():
	# Start with everything invisible
	container.modulate.a = 0
	bg_overlay.modulate.a = 0
	
	# Fade in background
	var tween = create_tween()
	tween.tween_property(bg_overlay, "modulate:a", 0.85, 0.3)
	tween.tween_property(container, "modulate:a", 1.0, 0.4)
	
	# Bounce in title
	title_label.scale = Vector2(0.3, 0.3)
	tween.parallel().tween_property(title_label, "scale", Vector2(1.0, 1.0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func update_attempts_display():
	if Globals:
		attempts_label.text = "Attempts: " + str(Globals.attempts)

func _on_play_button_pressed():
	if not is_visible_menu:
		return
	start_game()

func start_game():
	is_visible_menu = false
	
	# Mark that player has started at least once
	if Globals:
		Globals.has_started_once = true
	
	# Animate out
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(container, "modulate:a", 0.0, 0.3)
	tween.tween_property(bg_overlay, "modulate:a", 0.0, 0.3)
	tween.tween_property(title_label, "scale", Vector2(1.5, 1.5), 0.3)
	
	await tween.finished
	emit_signal("game_started")
	queue_free()
