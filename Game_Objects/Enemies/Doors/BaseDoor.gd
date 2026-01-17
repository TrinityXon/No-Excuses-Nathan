extends Node2D

@export var nextLevel: PackedScene

func _on_pickup_has_picked(body):
	if nextLevel:
		get_tree().change_scene_to_packed(nextLevel)
	else:
		print("no level assigned")
