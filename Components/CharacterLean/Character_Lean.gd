extends Node2D

@export var lean_offset: float
@export var movedir: float
@export var delta: float
@export var weight: float
@export var sprite: Sprite2D

func lean(lean_offset: float = lean_offset, movedir: float = movedir, delta: float = delta, weight: float = weight, sprite = sprite):
	if movedir < 0:
		if sprite:
			sprite.global_rotation = lerp(sprite.global_rotation, -lean_offset, weight * delta)
	elif movedir > 0:
		if sprite:
			sprite.global_rotation = lerp(sprite.global_rotation, lean_offset, weight * delta)
	else:
		if sprite:
			sprite.rotation = lerp(sprite.global_rotation, 0.0, weight/2 * delta)
