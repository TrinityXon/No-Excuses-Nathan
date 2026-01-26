extends Node2D

@export var healthIncrease = 10

func _on_pickup_has_picked(body):
	if body.has_node("healthMonitor"):
		var monitor = body.get_node("healthMonitor")
		
		if monitor.has_method("procureHealth"):
			monitor.procureHealth(healthIncrease)
			print(healthIncrease)
			destroyKit()

func destroyKit():
	queue_free()
