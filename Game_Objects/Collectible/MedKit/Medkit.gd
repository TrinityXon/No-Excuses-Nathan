extends Node2D

@export var healthIncrease = 10
@export var pickupSound: AudioStreamPlayer2D


func _on_pickup_has_picked(body):
	if body.has_node("healthMonitor"):
		var monitor = body.get_node("healthMonitor")
		
		if monitor.has_method("procureHealth"):
			monitor.procureHealth(healthIncrease)
			print(healthIncrease)
			destroyKit()

func destroyKit():
	if pickupSound != null:
		pickupSound.play()
		visible = false
		await pickupSound.finished
		queue_free()
	else:
		queue_free()
