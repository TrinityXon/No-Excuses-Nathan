extends Button

@export var soundEffectPress: AudioStreamPlayer2D

func _ready():
	button_down.connect(playSound)

func playSound():
	soundEffectPress.play()
