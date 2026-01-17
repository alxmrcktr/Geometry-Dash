extends CanvasLayer

# Geometry Dash style deep blue pulsating background with grid pattern

var time: float = 0.0
var pulse_speed: float = 1.5

@onready var bg1 = $BGGradient1
@onready var bg2 = $BGGradient2
@onready var bg3 = $BGGradient3
@onready var accent = $BGAccent

func _process(delta):
	time += delta
	
	# Subtle pulse
	var pulse = (sin(time * pulse_speed) + 1.0) * 0.5
	
	# Deep blue colors with pulse
	var base_brightness = 0.06 + pulse * 0.02
	var mid_brightness = 0.10 + pulse * 0.03
	var top_brightness = 0.15 + pulse * 0.04
	
	bg1.color = Color(0, base_brightness * 0.4, base_brightness, 1)
	bg2.color = Color(0, mid_brightness * 0.5, mid_brightness, 1)
	bg3.color = Color(0, top_brightness * 0.6, top_brightness, 1)
	accent.color = Color(0, 0.25 + pulse * 0.1, 0.4 + pulse * 0.15, 1)
