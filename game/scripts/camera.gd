extends Camera2D

var offset_x: float = 300.0

func _ready():
	make_current()

func _process(_delta):
	var player = get_node_or_null("../Player")
	if player:
		global_position.x = player.global_position.x + offset_x
		global_position.y = 360
