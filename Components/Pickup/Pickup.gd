extends Area2D

var isInPickRange = false
var playerBody

signal hasPicked(body)

func _input(event):
	if Input.is_action_just_pressed("Pickup") and isInPickRange:
		hasPicked.emit(playerBody)


func _on_body_entered(body):
	isInPickRange = true
	playerBody = body

func _on_body_exited(body):
	isInPickRange = false
	playerBody = body
