extends Node2D

@export var shouldFlip: bool = false
@onready var sprite = $Sprite2D

func _process(delta):
	if shouldFlip:
		sprite.flip_h
