extends Node2D

@onready var buttonRef: Button = $Button
@onready var labelRef: Label = $Label

@export var displayText: String
@export var levelpath: String
@export var pressAudio: AudioStreamPlayer2D

var soundDuration: float

func  _ready():
	if displayText != '': labelRef.text = displayText
	if buttonRef != null:
		buttonRef.button_down.connect(switchLevels)
	
func switchLevels():
	pressAudio.play()
	await pressAudio.finished
	if levelpath != '':
		get_tree().change_scene_to_file(levelpath)
	else:
		print('no level assigned')
