extends CharacterBody2D

const SPEED = 350.0
const JUMP_VELOCITY = -750.0
const GRAVITY = 3500.0

var is_dead = false
var is_complete = false
var game_started = false
var rotation_speed = 6.0
var death_spin_speed = 25.0

@onready var sprite = $Sprite2D

func _ready():
	# Wait for start menu
	set_physics_process(false)

func start_game():
	game_started = true
	set_physics_process(true)

func _physics_process(delta):
	if is_dead:
		sprite.rotation += death_spin_speed * delta
		sprite.modulate.a -= delta * 2.0
		return
	
	if is_complete:
		return
	
	velocity.x = SPEED
	velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if not is_on_floor():
		sprite.rotation += rotation_speed * delta
	else:
		sprite.rotation = snappedf(sprite.rotation, PI / 2)
	
	move_and_slide()
	
	if is_on_wall():
		die()
	
	if global_position.y > 800:
		die()
	
	# Level complete check
	if global_position.x > 12000:
		level_complete()

func die():
	if is_dead or is_complete:
		return
	is_dead = true
	velocity = Vector2.ZERO
	
	# Increment attempts
	if Globals:
		Globals.attempts += 1
	
	spawn_death_particles()
	
	await get_tree().create_timer(0.8).timeout
	get_tree().reload_current_scene()

func level_complete():
	if is_complete:
		return
	is_complete = true
	velocity = Vector2.ZERO
	
	# Play victory animation
	spawn_victory_particles()
	
	# Animate player
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "rotation", sprite.rotation + TAU * 2, 0.8)
	tween.tween_property(sprite, "modulate", Color(1, 1, 0.5, 1), 0.3)
	
	await get_tree().create_timer(0.5).timeout
	
	# Show level complete screen
	var complete_scene = preload("res://scenes/level_complete.tscn")
	var complete_ui = complete_scene.instantiate()
	get_tree().current_scene.add_child(complete_ui)

func spawn_death_particles():
	for i in range(8):
		var particle = ColorRect.new()
		particle.size = Vector2(10, 10)
		particle.color = Color(0, 1, 0.4, 1)
		particle.position = global_position - Vector2(5, 5)
		get_parent().add_child(particle)
		
		var angle = i * PI / 4
		var speed = randf_range(200, 400)
		var vel = Vector2(cos(angle), sin(angle)) * speed
		
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(particle, "position", particle.position + vel * 0.5, 0.5)
		tween.tween_property(particle, "modulate:a", 0.0, 0.5)
		tween.chain().tween_callback(particle.queue_free)

func spawn_victory_particles():
	var colors = [Color(1, 0.8, 0), Color(0, 1, 0.5), Color(0, 0.8, 1), Color(1, 0.3, 0.5)]
	for i in range(16):
		var particle = ColorRect.new()
		particle.size = Vector2(12, 12)
		particle.color = colors[i % colors.size()]
		particle.position = global_position - Vector2(6, 6)
		get_parent().add_child(particle)
		
		var angle = i * PI / 8
		var speed = randf_range(250, 500)
		var vel = Vector2(cos(angle), sin(angle)) * speed
		
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(particle, "position", particle.position + vel * 0.7, 0.8).set_ease(Tween.EASE_OUT)
		tween.tween_property(particle, "modulate:a", 0.0, 0.8)
		tween.tween_property(particle, "rotation", randf_range(-5, 5), 0.8)
		tween.chain().tween_callback(particle.queue_free)

func launch(launch_velocity: float):
	if is_dead or is_complete:
		return
	velocity.y = launch_velocity

func _on_hit_obstacle():
	die()
