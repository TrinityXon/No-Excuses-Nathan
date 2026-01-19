extends Control

@export var level: String
func _on_play_pressed():
	if level != '':
		get_tree().change_scene_to_file(level)
	else:
		print("no level to transition")
func _on_options_pressed():
	# TODO - MAKE A PROPER OPTIONS MENU LATER
	pass

func _on_quit_pressed():
	get_tree().quit()
