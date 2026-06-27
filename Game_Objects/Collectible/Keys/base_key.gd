extends Node2D

@export var keyCode: int = 0

func _on_pickup_has_picked(body):
	var existingdir = body.fetchKeyDirectory()
	
	for i in existingdir:
		if i == keyCode:
			print('The code is invalid')
			return
		elif i != keyCode:
			print('The code is valid')
			pass
	
	print('The code is valid')
	body.addToKeyDirectory(keyCode)
	await get_tree().create_timer(0.1).timeout
	self.queue_free()
