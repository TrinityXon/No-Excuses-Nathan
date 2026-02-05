extends Node2D

@export var level: String
@export var visibleSprite: bool = true
@onready var door = $Door
@export var shouldLoadMenu: bool = false
@export var menu: String

@export var door_open: AudioStreamPlayer2D


func _ready():
	if not visibleSprite:
		door.visible = false


func _on_pickup_has_picked(body):
	door_open.play()
	
	await door_open.finished
	if not shouldLoadMenu:
		if level != '':
			get_tree().change_scene_to_file(level)
		else:
			print("no level assigned")
	else:
		var newMenu = load(menu).instantiate()
		get_tree().current_scene.add_child(newMenu)
