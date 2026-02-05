extends CanvasLayer

@onready var level_select = $ColorRect/LevelSelect
@onready var main_menu = $ColorRect/MainMenu
@onready var restart_btn = $ColorRect/Restart
@onready var quit_btn = $ColorRect/Quit
@onready var button_press: AudioStreamPlayer2D = $ButtonPress

@export var levelScreen: String
@export var mainMenu: String

var sfxDuration
func _ready():
	get_tree().paused = true
	level_select.button_down.connect(level_select_switch)
	main_menu.button_down.connect(main_menu_switch)
	restart_btn.button_down.connect(_has_restarted)
	quit_btn.button_down.connect(_has_quit)
	
	sfxDuration = button_press.stream.get_length()

func level_select_switch():
	customScreenSwitch(levelScreen, 'No assigned level')

func main_menu_switch():
	customScreenSwitch(mainMenu, 'No assigned level')

func customScreenSwitch(scenePath: String, debugMessage: String):
	await get_tree().create_timer(sfxDuration).timeout
	if scenePath != '':
		get_tree().change_scene_to_file(scenePath)
		get_tree().paused = false
	else:
		print(debugMessage)

func _has_restarted():
	await get_tree().create_timer(sfxDuration, true).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()

func _has_quit():
	await get_tree().create_timer(sfxDuration).timeout
	get_tree().quit()

