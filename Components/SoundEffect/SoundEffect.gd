extends Node2D

@onready var audioPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var audio: AudioStreamMP3
@export var shouldRandomizePitch: bool = false
@export var randomPitchParamLow: float
@export var randomPitchParamHigh: float
@export var soundVol: float


func _ready():
	audioPlayer.stream = audio
	
	if soundVol != 0:
		audioPlayer.volume_db = soundVol
		
func play_effect():
	if shouldRandomizePitch:
		audioPlayer.pitch_scale = randf_range(randomPitchParamLow, randomPitchParamHigh)
	
	
	audioPlayer.play()
