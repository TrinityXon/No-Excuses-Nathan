extends Area2D

var healthMonitor
var emitBus

var isOnFloor: bool

@onready var icon = $Icon
@onready var damage_sound = $DamageSound

@export var maxHealth: float
@export var isInvincible: bool

@onready var groundRay = $groundCheck

@export var flipSprite: bool = false

@export var gravityStrength: float = 450
@export var gravityEnabled: bool = false

@export var damage_anim: AnimationPlayer
@export var damage_anim_path: String

@export var squash_stretch: Node2D

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
	
	if damage_anim == null or damage_anim_path == null or damage_anim_path == '':
		damage_anim = $Damage
		damage_anim_path = 'Damage' 

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
	squash_stretch.stretch(30)
	await get_tree().create_timer(0.1).timeout
	icon.visible = false
	$Timer.start()
	

func hasDamage(damageAmount):
	squash_stretch.stretch()
	emitBus.emit_event("hit")


func _on_timer_timeout():
	print('has destroyed')
	queue_free()


func _on_health_monitor_has_taken_damage(damageAmount):
	damage_sound.play()
	print('hit triggered')
