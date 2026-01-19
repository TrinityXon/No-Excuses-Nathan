extends StaticBody2D

@onready var spriteRef: Sprite2D = %Icon
@export var newColor: Color = Color.BLACK
@export var shouldModulate: bool = true


func _ready():
	if spriteRef and shouldModulate:
		spriteRef.modulate = newColor
	else:
		print("sprite not found - ground level base")
