extends Node2D

@onready var squash_stretch = $SquashStretch

func _on_button_mouse_entered():
	squash_stretch.stretch_only()


func _on_button_mouse_exited():
	squash_stretch.squash()
