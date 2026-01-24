extends Area2D

# 1 block = 40px wide, 40px high
# 4 blocks jump height = 160px
# Velocity = -sqrt(2 * gravity * height) = -sqrt(2 * 3500 * 160) approx -1060
const LAUNCH_VELOCITY = -1060.0 

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and body.has_method("launch"):
		# Stationary launch (no animation)
		body.launch(LAUNCH_VELOCITY)
		print("Pad: Player launched 4 blocks high")
