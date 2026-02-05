extends Node2D

var hasHitStopped: bool = false
var regularTimeScale: float = 1


func hitstop(freeze_dur: float):
	if not hasHitStopped:
		Engine.time_scale = 0
		hasHitStopped = true
		
		await get_tree().create_timer(freeze_dur, true, false, true).timeout
		Engine.time_scale = regularTimeScale
		hasHitStopped = false
	else:
		pass
