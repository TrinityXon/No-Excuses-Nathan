extends StaticBody2D

@onready var spriteRef: Sprite2D = %Icon
@export var newColor: Color = Color.BLACK

func _ready():
	if spriteRef:
		spriteRef.modulate = newColor
	else:
		print("sprite not found - ground level base")
