extends Camera2D

@export var max_shake: float = 0.5
@export var shake_fade: float = 15

var shake_strength = 0.0

func trigger_shake():
	shake_strength = max_shake

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	else:
		offset = Vector2.ZERO
