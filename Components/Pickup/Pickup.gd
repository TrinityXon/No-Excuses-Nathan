extends Area2D

var isInPickRange = false
var playerBody

@export var pickup_text: Label
@export var pickup_prompt: String
@export var interactionText: String

@export var isOneTime: bool = false
var alreadyPicked

var hasAnimCompleted: bool = true

signal hasPicked(body)

func _ready():
	if !pickup_text:
		pickup_text = $Pickup_Text
	
	if interactionText == null or interactionText == '':
		interactionText = 'Interacted👍'
	
	if pickup_prompt != null and pickup_prompt != '' and pickup_text != null:
		pickup_text.text = pickup_prompt
	elif pickup_prompt != null and pickup_prompt != '':
		pickup_text.text = 'F to interact'
	else:
		pass
	
func _input(event):
	if Input.is_action_just_pressed("Pickup") and isInPickRange and not alreadyPicked:
		await pickup_animation(pickup_text, interactionText, Color.GREEN, 0.2)
		
		hasPicked.emit(playerBody)


func _on_body_entered(body):
	if pickup_text:
		pickup_text.visible = true
	isInPickRange = true
	playerBody = body

func _on_body_exited(body):
	if pickup_text:
		pickup_text.visible = false
	isInPickRange = false
	playerBody = body


func pickup_animation(text_l: Label, interactionText: String, collectionColor: Color, duration: float):
	hasAnimCompleted = false
	text_l.text = interactionText
	text_l.modulate = collectionColor
	await get_tree().create_timer(duration).timeout
	text_l.modulate = Color.WHITE
	await get_tree().create_timer(duration/2.5).timeout
	text_l.text = ''
	hasAnimCompleted = true
	
