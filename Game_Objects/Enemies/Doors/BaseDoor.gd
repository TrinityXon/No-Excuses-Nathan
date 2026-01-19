extends Node2D

@export var level: String
func _on_pickup_has_picked(body):
	if level != '':
		get_tree().change_scene_to_file(level)
	else:
		print("no level assigned")
