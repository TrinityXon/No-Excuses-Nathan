extends Node2D

func _on_pickup_has_picked(body):
	if body.has_method("changeMovement"):
		body.changeMovement()
