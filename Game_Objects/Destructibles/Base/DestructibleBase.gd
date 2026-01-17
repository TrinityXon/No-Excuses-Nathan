extends Area2D

var healthMonitor
var emitBus

var isOnFloor: bool

@onready var icon = $Icon
@export var maxHealth: float
@export var isInvincible: bool

@onready var groundRay = $groundCheck

@export var flipSprite: bool = false

@export var gravityStrength: float = 450
@export var gravityEnabled: bool = false

func _ready():
	healthMonitor = get_node("healthMonitor")
	emitBus = get_node("EmitBus")
	
	healthMonitor.maxHealth = maxHealth
	healthMonitor.isInvincible = isInvincible
	
	if healthMonitor:
		healthMonitor.hasTakenDamage.connect(hasDamage)
		healthMonitor.hasDied.connect(destruction)
	else:
		print("No health monitor specified")
	
	if flipSprite:
		scale.x *= -1

func _physics_process(delta):
	if not isOnFloor and gravityEnabled:
		position.y += gravityStrength * delta

func _process(delta):
	if groundRay.is_colliding():
		isOnFloor = true
	else:
		isOnFloor = false

func destruction():
	emitBus.emit_event("destroy")
	icon.visible = false
	$Timer.start()
	

func hasDamage(damageAmount):
	emitBus.emit_event("hit")


func _on_timer_timeout():
	print('has destroyed')
	queue_free()
