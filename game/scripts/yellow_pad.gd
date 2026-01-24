extends Area2D

const LAUNCH_VELOCITY = -1200.0  # Stronger jump than normal
var is_animating = false

@onready var sprite = $Sprite2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and body.has_method("launch"):
		# Launch the player
		body.launch(LAUNCH_VELOCITY)
		play_bounce_animation()

func play_bounce_animation():
	if is_animating:
		return
	is_animating = true
	
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.2, 0.7), 0.1)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.15).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	is_animating = false
