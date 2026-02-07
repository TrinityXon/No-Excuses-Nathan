extends Area2D

var isInPickRange = false
var playerBody

@onready var pickup_text = $Pickup_Text
@export var pickup_prompt: String

signal hasPicked(body)

func _ready():
	pickup_text.text = pickup_prompt

func _input(event):
	if Input.is_action_just_pressed("Pickup") and isInPickRange:
		hasPicked.emit(playerBody)


func _on_body_entered(body):
	pickup_text.visible = true
	isInPickRange = true
	playerBody = body

func _on_body_exited(body):
	pickup_text.visible = false
	isInPickRange = false
	playerBody = body
