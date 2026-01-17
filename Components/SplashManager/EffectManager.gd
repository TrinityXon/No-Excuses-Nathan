extends Node

@export var effect: PackedScene
@export var animation: String

@export var triggerName: String
@export var bus: Node

func _ready():
	if bus:
		bus.event_emitted.connect(emitManager)
	
	print(triggerName)

func playEffect():
	var spawnedEffect = effect.instantiate()
	
	add_child(spawnedEffect)
	spawnedEffect.position = self.position
	
	spawnedEffect.play(animation)
	print("has run")
	
	await spawnedEffect.animation_finished
	spawnedEffect.queue_free()


func emitManager(eventName):
	if triggerName != eventName:
		print("wrong key")
		return
	
	print("correct key")
	playEffect()
