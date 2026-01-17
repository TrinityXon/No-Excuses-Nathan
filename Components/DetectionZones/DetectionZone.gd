extends Area2D

signal hasDetected
signal hasLostVision

func _ready():
	self.body_entered.connect(_on_detect)
	self.body_exited.connect(_on_lost_vision)

func _on_detect(body):
	hasDetected.emit(body)


func _on_lost_vision(body):
	hasLostVision.emit(body)
