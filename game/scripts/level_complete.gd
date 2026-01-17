extends CanvasLayer

@onready var title = $CenterContainer/VBoxContainer/Title
@onready var stats_label = $CenterContainer/VBoxContainer/Stats
@onready var replay_btn = $CenterContainer/VBoxContainer/ButtonsContainer/ReplayButton
@onready var container = $CenterContainer/VBoxContainer
@onready var bg_overlay = $BGOverlay
@onready var particles_container = $ParticlesContainer

func _ready():
	play_complete_animation()

func play_complete_animation():
	# Start invisible
	container.modulate.a = 0
	bg_overlay.modulate.a = 0
	
	# Spawn celebration particles
	spawn_celebration_particles()
	
	# Update stats
	if Globals:
		stats_label.text = "Completed in " + str(Globals.attempts) + " attempts!"
	
	# Animate in
	var tween = create_tween()
	tween.tween_property(bg_overlay, "modulate:a", 0.9, 0.5)
	tween.tween_property(container, "modulate:a", 1.0, 0.5)
	
	# Bounce title
	title.scale = Vector2(0.1, 0.1)
	title.rotation = -0.3
	tween.parallel().tween_property(title, "scale", Vector2(1.0, 1.0), 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(title, "rotation", 0.0, 0.4).set_ease(Tween.EASE_OUT)

func spawn_celebration_particles():
	# Create colorful particles bursting from center
	var colors = [
		Color(0, 1, 0.5, 1),   # Cyan-green
		Color(1, 0.8, 0, 1),   # Gold
		Color(0, 0.8, 1, 1),   # Cyan
		Color(1, 0.2, 0.5, 1), # Pink
		Color(0.5, 0, 1, 1)    # Purple
	]
	
	for i in range(30):
		var particle = ColorRect.new()
		particle.size = Vector2(randf_range(8, 16), randf_range(8, 16))
		particle.color = colors[i % colors.size()]
		particle.position = Vector2(640, 360)  # center
		particles_container.add_child(particle)
		
		var angle = randf() * TAU
		var speed = randf_range(300, 600)
		var target_pos = particle.position + Vector2(cos(angle), sin(angle)) * speed
		
		var delay = randf() * 0.3
		var tween = create_tween()
		tween.tween_interval(delay)
		tween.tween_property(particle, "position", target_pos, randf_range(0.8, 1.5)).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(particle, "modulate:a", 0.0, randf_range(1.0, 1.8))
		tween.parallel().tween_property(particle, "rotation", randf_range(-3, 3), 1.0)
		tween.tween_callback(particle.queue_free)

func _on_replay_button_pressed():
	# Reset attempts for new playthrough
	if Globals:
		Globals.attempts = 1
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	if Globals:
		Globals.has_started_once = false
		Globals.attempts = 1
	get_tree().reload_current_scene()

func _input(event):
	# Only allow replay button, not keyboard shortcuts
	pass
