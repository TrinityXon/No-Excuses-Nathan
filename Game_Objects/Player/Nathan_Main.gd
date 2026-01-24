extends CharacterBody2D


# Control variables
@export var maxSpeed = 600
@export var minSpeed = 0
@export var maxSpeedVert = 300
@export var minSpeedVert = 0
@export var acceleration: float = 3

@export var jumpSpeed = 450
@export var gravity = 600

var Speed = maxSpeed
var climbSpeed = maxSpeed
var direction: float
var directionYClimb: float
var airMovementMultiplier = 0.7
var gravityEnabled: bool = true

enum playerStates {default, armed}
var canClimb: bool = false
var curStates: playerStates = playerStates.default

# Node References
@onready var gunParent = $gunParent
@onready var playerSprite = $Icon
@onready var ammoLabel = $CanvasLayer/ColorRect/Label
@onready var playerCollision = $CollisionShape2D
@onready var ceilingCheck = %CeilingCheck
@onready var progress_bar = %ProgressBar
@onready var health_monitor = %healthMonitor

var emitBus

@export var armedTex: Texture
@onready var defaultTex: Texture = playerSprite.texture

var state_triggered = false

var allguns

var gunIndices
var selectedGun = 0
var gun

var healthMonitor

var isCrouching: bool = false
@export var canCrouch = false


@export var deathMenu: PackedScene

func _ready():
	allguns = gunParent.get_children()
	gunIndices = allguns.size()
	gun = gunParent.get_child(selectedGun)
	
	progress_bar.max_value = health_monitor.maxHealth
	
	switch_gun()
	healthMonitor = get_node("healthMonitor")
	emitBus = get_node("EmitBus")
	
	if healthMonitor:
		healthMonitor.hasDied.connect(_on_death)
		healthMonitor.hasTakenDamage.connect(_on_damage)
		
	if gun:
		ammoLabel.text = "Ammo: " + str(gun.ammoCnt)
		gun.ammoChange.connect(trackAmmo)

# Game loop
func _physics_process(delta):
	# Start Stuff
	manage_states()
	
	# Log direction and set it to velocity on the x axis
	direction = Input.get_axis("MoveLeft", "Move_Right")
	directionYClimb = Input.get_axis("Move_Down", "Move_Up") 
	var targetSpeed = Speed * direction
	var targetSpeedY = climbSpeed * directionYClimb
	var accel = acceleration
	
	
	if not is_on_floor():
		accel *= airMovementMultiplier
	
	velocity.x = lerp(velocity.x, targetSpeed, accel * delta)
	
	if curStates == playerStates.armed:
		if Input.is_action_pressed("Shoot"):
			gun.shoot()
	
	if canClimb:
	# CLIMB MODE
		velocity.y = lerp(velocity.y,targetSpeedY,accel * delta)
	else:
	# NORMAL MODE
		if not is_on_floor():
			velocity.y += gravity * delta
	
	flip_player()
	move_and_slide()


func _process(delta):
	progress_bar.value = healthMonitor.currentHealth

# Handle Input
func _input(event):
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y -= jumpSpeed
		print("Jump")
	
	if Input.is_action_just_pressed("Shoot"):
		if curStates == playerStates.armed:
			if gun.has_method("shoot"):
				gun.shoot()
			else:
				print("hey")
	
	if Input.is_action_just_pressed("equip"):
		if curStates == playerStates.armed:
			change_state(playerStates.default)

		elif curStates == playerStates.default:
			change_state(playerStates.armed)
	
	if Input.is_action_just_pressed("SwitchForward") and curStates == playerStates.armed:
		selectedGun = (selectedGun + 1) % gunIndices
		switch_gun()
		
	if Input.is_action_just_pressed("SwitchBack") and curStates == playerStates.armed:
		selectedGun = (selectedGun - 1 + gunIndices) % gunIndices
		switch_gun()
	
	if Input.is_action_just_pressed("crouch") and canCrouch:
		if not isCrouching:
			crouch()
		elif isCrouching:
			unCrouch()

# flip sprite based on direction
func flip_player():
	if direction != 0:
		gunParent.scale.x = sign(direction)
		if direction < 0: playerSprite.flip_h = true
		if direction > 0: playerSprite.flip_h = false


func change_state(newState):
	if newState == curStates:
		return
		
	curStates = newState

func manage_states():
	match curStates:
		playerStates.armed:
			switchPlayerArmed(Node.PROCESS_MODE_INHERIT, true, armedTex, gunParent, playerSprite)
		playerStates.default:
			switchPlayerArmed(Node.PROCESS_MODE_DISABLED, false, defaultTex, gunParent, playerSprite)

# Only use for manage_states()
func switchPlayerArmed(process, visibility: bool, texture: Texture, host: Node2D, spriteHolder: Sprite2D):
	host.process_mode = process
	host.visible = visibility
	spriteHolder.texture = texture


func _on_death():
	die()
	
func _on_damage(damageAmount: float):
	if emitBus:
		emitBus.emit_event("Damage")
	
func die():
	if deathMenu:
		var spawnedMenu = deathMenu.instantiate()
		get_tree().current_scene.add_child(spawnedMenu)
	
func trackAmmo(ammunition):
	ammoLabel.text = "Ammo: " + str(ammunition)


func switch_gun():
	for g in allguns:
		g.visible = false
		
		if g.is_connected("ammoChange", trackAmmo):
			g.disconnect("ammoChange", trackAmmo)
	
	
	gun = allguns[selectedGun]
	gun.visible = true
	
	if not gun.is_connected("ammoChange", trackAmmo):
		gun.connect("ammoChange", trackAmmo)
	
	ammoLabel.text = "Ammo: " + str(gun.ammoCnt)
	
	
func crouch():
	if isCrouching:
		return
	
	
	playerSprite.scale.y /= 2
	playerCollision.scale.y /= 2
	Speed /= 2
	
	isCrouching = true
	
func unCrouch():
	if not isCrouching:
		return
	
	if ceilingCheck.is_colliding():
		return
	
	playerSprite.scale.y *= 2
	playerCollision.scale.y *= 2
	Speed *= 2
	
	isCrouching = false

func changeMovement(climb: bool):
	if climb:
		canClimb = true
	if not climb:
		canClimb = false
