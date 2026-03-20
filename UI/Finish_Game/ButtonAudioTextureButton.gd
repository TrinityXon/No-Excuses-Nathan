extends TextureButton

@export var soundEffectPress: AudioStreamPlayer2D
@export var hover_scale: float = 1.1
@export var lerp_speed: float = 8.0


var early_scale: Vector2
var target_scale: Vector2

func _ready():
	button_down.connect(playSound)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	early_scale = self.scale
	target_scale = early_scale

func _process(delta):
	scale = scale.lerp(target_scale, lerp_speed * delta)

func playSound():
	soundEffectPress.play()

func _on_mouse_entered():
	target_scale = early_scale * hover_scale

func _on_mouse_exited():
	target_scale = early_scale
