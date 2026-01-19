extends Control

@export var nextLevel: PackedScene

func _on_play_pressed():
	if nextLevel != null:
		get_tree().change_scene_to_packed(nextLevel)
	else:
		print("no level to transition")
func _on_options_pressed():
	# TODO - MAKE A PROPER OPTIONS MENU LATER
	pass

func _on_quit_pressed():
	get_tree().quit()
