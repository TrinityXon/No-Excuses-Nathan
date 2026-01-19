extends Control

@export var nextLevel: PackedScene

func _ready():
	if GlobalVars.nextLevelSceneMainMenu == null and nextLevel != null:
		GlobalVars.nextLevelSceneMainMenu = nextLevel
		
	print(GlobalVars)
func _on_play_pressed():
	if GlobalVars.nextLevelSceneMainMenu != null:
		get_tree().change_scene_to_packed(GlobalVars.nextLevelSceneMainMenu)
	else:
		print("no level to transition")
func _on_options_pressed():
	# TODO - MAKE A PROPER OPTIONS MENU LATER
	pass

func _on_quit_pressed():
	get_tree().quit()
