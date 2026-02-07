extends Camera2D

@export var max_shake: float = 1.5
@export var shake_fade: float = 30

var shake_strength = 0.0

func trigger_shake(shake_amp: float = 1.5, shake_speed = 30):
	shake_strength = shake_amp
	shake_speed = shake_fade

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	else:
		offset = Vector2.ZERO
