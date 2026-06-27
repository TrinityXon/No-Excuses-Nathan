extends Node2D

@export var level: String
@export var visibleSprite: bool = true
@onready var door = $Door
@export var shouldLoadMenu: bool = false
@export var shouldTeleport: bool = false
@export var teleportLocation: Vector2 = Vector2(0, 0)
@export var menu: String
@export var shouldUseKey: bool = false

@export var door_open: AudioStreamPlayer2D

@export var keyCode: int = 0

func _ready():
	if not visibleSprite:
		door.visible = false


func _on_pickup_has_picked(body):
	if shouldUseKey:
		var keydir: Array[int] = body.fetchKeyDirectory()
		if keydir.has(keyCode):
			door_open_manager(body)
		else:
			pass
			#TODO: ADD KEY REJECT SOUNDS
	else:
		door_open_manager(body)

func door_open_manager(body):
	# Should first check if this is a level change door, or a location change one
			if not shouldTeleport:
				# if it isn't a teleport door, change level
				
				# Wait for door open sound to finish
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
			elif shouldTeleport:
				# If should change location, do this:
				door_open.play()
				await door_open.finished
				# wait for sound to finish playing
				
				# 1. trigger a black screen. 2. Change location, 3. Un-trigger the black screen
				body.trigger_black_screen(true) # Turns the screen black
				body.global_position = teleportLocation
				await get_tree().create_timer(1).timeout
				body.trigger_black_screen(false) # Turns the screen back to normal
