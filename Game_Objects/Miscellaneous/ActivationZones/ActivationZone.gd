extends Area2D

signal hasEnteredZone



func _on_body_entered(body):
	hasEnteredZone.emit()
