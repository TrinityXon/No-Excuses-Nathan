extends Node2D

var hostileDir


func get_hostile_position(position: Vector2):
	hostileDir = position
	print('message received and simultaneously given', name)
