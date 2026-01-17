extends Area2D

@export var defaultColor: Color = Color(Color.GREEN, 0.3)
@export var detectionColor: Color = Color(Color.RED, 0.3)
@onready var collision_polygon_2d = $CollisionPolygon2D


signal hasDetected
signal hasLostVision

func _ready():
	collision_polygon_2d.changeColor(defaultColor)
	self.body_entered.connect(_on_detect)
	self.body_exited.connect(_on_lost_vision)

func _on_detect(body):
	hasDetected.emit(body)
	collision_polygon_2d.changeColor(detectionColor)


func _on_lost_vision(body):
	hasLostVision.emit(body)
	
