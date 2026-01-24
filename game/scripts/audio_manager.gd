extends Node

# Singleton for managing game audio
var music_player: AudioStreamPlayer
var current_track = ""

func _ready():
	# Create music player
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Master"

func play_music(track_name: String, _loop: bool = true):
	var track_path = "res://music/" + track_name
	
	# Stop and reset to ensure full restart
	if music_player.playing:
		music_player.stop()
	
	if ResourceLoader.exists(track_path):
		var stream = load(track_path)
		if stream:
			music_player.stream = stream
			music_player.play()
			current_track = track_name
			print("AudioManager: Playing " + track_name)
	else:
		print("AudioManager: Track not found: " + track_path)

func stop_music():
	music_player.stop()
	current_track = ""

func set_volume(volume_db: float):
	music_player.volume_db = volume_db
