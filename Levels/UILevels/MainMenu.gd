extends Control

@export var level: String
@export var pressSound: AudioStreamPlayer2D

var audioDuration: float

func _ready():
	audioDuration = pressSound.stream.get_length()

func _on_play_pressed():
	await get_tree().create_timer(audioDuration, true).timeout
	if level != '':
		get_tree().change_scene_to_file(level)
	else:
		print("no level to transition")
func _on_options_pressed():
	# TODO - MAKE A PROPER OPTIONS MENU LATER
	pass

func _on_quit_pressed():
	await get_tree().create_timer(audioDuration, true).timeout
	get_tree().quit()
