extends Node

signal event_emitted(event: String)

func emit_event(triggerPassBy: String):
	event_emitted.emit(triggerPassBy)
