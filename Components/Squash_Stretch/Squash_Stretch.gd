extends Node2D

@export var sprite_to_stretch: Sprite2D
@export_range(0, 100) var stretch_percent: int = 30
@export var recovery_speed: float = 8.0

var original_scale: Vector2
var target_scale: Vector2

func _ready():
	original_scale = sprite_to_stretch.scale
	target_scale = original_scale

func _process(delta):
	# Move sprite toward target scale
	sprite_to_stretch.scale = sprite_to_stretch.scale.lerp(target_scale, recovery_speed * delta)
	
	# Slowly recover target scale back to normal
	target_scale = target_scale.lerp(original_scale, 6 * delta)

func stretch(scale: float = recovery_speed):
	var amount = stretch_percent / 100.0
	
	# Horizontal squash, vertical stretch
	target_scale = Vector2(
		original_scale.x * (1.0 + amount),
		original_scale.y * (1.0 - amount)
	)
