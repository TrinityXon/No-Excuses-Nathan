extends Node2D

@onready var buttonRef: Button = $Button
@onready var labelRef: Label = $Label

@export var displayText: String
@export var levelpath: String

func  _ready():
	if displayText != '': labelRef.text = displayText
	if buttonRef != null:
		buttonRef.button_down.connect(switchLevels)

func switchLevels():
	if levelpath != '':
		get_tree().change_scene_to_file(levelpath)
	else:
		print('no level assigned')
