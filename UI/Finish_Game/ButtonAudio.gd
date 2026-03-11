extends Button

@export var soundEffectPress: AudioStreamPlayer2D
@export var hover_scale: float = 1.1
@export var lerp_speed: float = 8.0

var target_scale: Vector2 = Vector2.ONE

func _ready():
	button_down.connect(playSound)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(delta):
	scale = scale.lerp(target_scale, lerp_speed * delta)

func playSound():
	soundEffectPress.play()

func _on_mouse_entered():
	target_scale = Vector2.ONE * hover_scale

func _on_mouse_exited():
	target_scale = Vector2.ONE
