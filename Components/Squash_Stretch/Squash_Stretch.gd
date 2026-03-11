extends Node2D

@export var sprite_to_stretch: Sprite2D
@export_range(0, 100) var stretch_percent: int = 30
@export var recovery_speed: float = 8.0

var original_scale: Vector2
var target_scale: Vector2


func _ready():
	if sprite_to_stretch == null:
		push_error("sprite_to_stretch is not assigned.")
		return
	
	original_scale = sprite_to_stretch.scale
	target_scale = original_scale


func _process(delta):
	sprite_to_stretch.scale = sprite_to_stretch.scale.lerp(target_scale, recovery_speed * delta)


# Combined squash + stretch (kept for compatibility)
func stretch(stretch_p: float = stretch_percent):
	var amount = stretch_p / 100.0
	
	target_scale = Vector2(
		original_scale.x * (1.0 + amount),
		original_scale.y * (1.0 - amount)
	)


# Only stretch vertically
func stretch_only(stretch_p: float = stretch_percent):
	var amount = stretch_p / 100.0
	
	target_scale = Vector2(
		original_scale.x,
		original_scale.y * (1.0 + amount)
	)


# Only squash vertically
func squash(stretch_p: float = stretch_percent):
	var amount = stretch_p / 100.0
	
	target_scale = Vector2(
		original_scale.x * (1.0 + amount),
		original_scale.y * (1.0 - amount)
	)


func reset_scale():
	target_scale = original_scale
