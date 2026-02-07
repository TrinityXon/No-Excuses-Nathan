extends CanvasLayer

@onready var flash_rect = $ColorRect
var isFlashing: bool = false


func screen_flash(f_colour: Color = Color.WHITE, duration: float = 0.08, strength: float = 0.4):
	if not isFlashing:
		flash_rect.color = f_colour
		flash_rect.modulate.a = strength
		isFlashing = true
		
		await get_tree().create_timer(duration).timeout
		
		flash_rect.modulate.a = 0
		isFlashing = false
	else:
		pass
