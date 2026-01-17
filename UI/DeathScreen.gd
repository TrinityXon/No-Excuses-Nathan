extends CanvasLayer

@onready var restart_btn = $ColorRect/Restart
@onready var quit_btn = $ColorRect/Quit

func _ready():
	get_tree().paused = true
	
	restart_btn.button_down.connect(_has_restarted)
	quit_btn.button_down.connect(_has_quit)

func _has_restarted():
	get_tree().reload_current_scene()
	get_tree().paused = false

func _has_quit():
	get_tree().quit()
