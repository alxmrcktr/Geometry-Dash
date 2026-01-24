extends Area2D

# Launch velocity calculated for 4 blocks high (160 pixels)
# With gravity 3500: velocity = sqrt(2 * gravity * height) = sqrt(2 * 3500 * 160) ≈ 1058
const LAUNCH_VELOCITY = -1060.0  # Makes player jump exactly 4 blocks high

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and body.has_method("launch"):
		# Launch the player upward
		body.launch(LAUNCH_VELOCITY)
