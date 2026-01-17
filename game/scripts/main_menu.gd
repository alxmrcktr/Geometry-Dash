extends CanvasLayer

signal level_selected(level_id: int)

var selected_level = 1

@onready var attempts_label = $CenterContainer/VBoxContainer/AttemptsLabel

func _ready():
	update_attempts()
	play_intro_animation()
	# Focus level 1 button
	$CenterContainer/VBoxContainer/LevelsContainer/Level1.grab_focus()

func update_attempts():
	if Globals and attempts_label:
		attempts_label.text = "Total Attempts: " + str(Globals.attempts - 1 if Globals.attempts > 0 else 0)

func play_intro_animation():
	var title = $CenterContainer/VBoxContainer/Title
	var container = $CenterContainer/VBoxContainer
	var bg = $BGOverlay
	
	container.modulate.a = 0
	bg.modulate.a = 0
	title.scale = Vector2(0.3, 0.3)
	
	var tween = create_tween()
	tween.tween_property(bg, "modulate:a", 0.95, 0.3)
	tween.tween_property(container, "modulate:a", 1.0, 0.4)
	tween.parallel().tween_property(title, "scale", Vector2(1.0, 1.0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _on_level1_pressed():
	selected_level = 1
	start_level()

func _on_level2_pressed():
	# Coming soon - do nothing or show message
	pass

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
