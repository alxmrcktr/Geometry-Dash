extends CanvasLayer

signal level_selected(level_id: int)

var selected_level = 1

@onready var attempts_label = $CenterContainer/VBoxContainer/AttemptsLabel

func _ready():
	print("MainMenu: Initialized")
	update_attempts()
	# Focus level 1 button
	var btn = get_node_or_null("CenterContainer/VBoxContainer/LevelsContainer/Level1")
	if btn:
		btn.grab_focus()
	
	# Ensure visibility even if animation is skipped
	var container = get_node_or_null("CenterContainer/VBoxContainer")
	var bg = get_node_or_null("BGOverlay")
	if container: container.modulate.a = 1.0
	if bg: bg.modulate.a = 0.95
	
	play_intro_animation()

func update_attempts():
	if Globals and attempts_label:
		attempts_label.text = "Total Attempts: " + str(Globals.attempts - 1 if Globals.attempts > 0 else 0)

func play_intro_animation():
	var title = get_node_or_null("CenterContainer/VBoxContainer/Title")
	var container = get_node_or_null("CenterContainer/VBoxContainer")
	var bg = get_node_or_null("BGOverlay")
	
	if not title or not container or not bg:
		return
		
	title.scale = Vector2(0.3, 0.3)
	var tween = create_tween()
	tween.tween_property(title, "scale", Vector2(1.0, 1.0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _on_level1_pressed():
	selected_level = 1
	start_level()

func _on_level2_pressed():
	selected_level = 2
	start_level()

func _on_level3_pressed():
	# Coming soon
	pass

func _on_level4_pressed():
	# Coming soon
	pass

func start_level():
	var container = $CenterContainer/VBoxContainer
	var bg = $BGOverlay
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(container, "modulate:a", 0.0, 0.3)
	tween.tween_property(bg, "modulate:a", 0.0, 0.3)
	
	await tween.finished
	emit_signal("level_selected", selected_level)
	queue_free()
