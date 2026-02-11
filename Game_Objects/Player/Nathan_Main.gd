extends CharacterBody2D


# Control variables
@export var maxSpeed = 600
@export var minSpeed = 0
@export var maxSpeedVert = 300
@export var minSpeedVert = 0
@export var acceleration: float = 3

@export var jumpSpeed = 450
@export var gravity = 600

@export var lean_offset: float = 15
@export var lean_weight: float = 8

@onready var character_lean: Node2D = $Character_Lean

@export var test_object: Node2D

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
@onready var equip_sound_effect = $EquipWeapon
@onready var jump = $Jump
@onready var hostile_dir_manager = $HostileDirManager

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

@onready var screenFlash = get_tree().get_first_node_in_group('ScreenFlash')
@onready var cameraRef = get_tree().get_first_node_in_group('Camera')


@export var deathMenu: PackedScene
@onready var jump_squeeze = $SquashStretch
@onready var land_squeeze = $LandStretch

var was_on_floor: bool = false

var public_delta: float

var hostileDir: Vector2
var kb_velocity: Vector2 = Vector2.ZERO
var kb_decay: float = 10.0

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
	
	if not was_on_floor and is_on_floor():
		print("Just landed")

	# Detect leaving ground (jump / fall)
	if was_on_floor and not is_on_floor():
		print("Left ground")

	public_delta = delta
	
	# Update for next frame
	was_on_floor = is_on_floor()
	

	character_lean.lean(0.05, direction, delta, lean_weight, playerSprite)
	
	velocity += kb_velocity
	kb_velocity = kb_velocity.lerp(Vector2.ZERO, kb_decay * delta)
	
	flip_player()
	move_and_slide()


func _process(delta):
	progress_bar.value = healthMonitor.currentHealth
	
	
# Handle Input
func _input(event):
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y -= jumpSpeed
		jump.play()
		jump_squeeze
		print("Jump")
	
	if Input.is_action_just_pressed("Shoot"):
		if curStates == playerStates.armed:
			if gun.has_method("shoot"):
				gun.shoot()
			else:
				print("hey")
	
	if Input.is_action_just_pressed("equip"):
		equip_sound_effect.play()
		if curStates == playerStates.armed:
			change_state(playerStates.default)

		elif curStates == playerStates.default:
			change_state(playerStates.armed)
	
	if Input.is_action_just_pressed("SwitchForward") and curStates == playerStates.armed:
		selectedGun = (selectedGun + 1) % gunIndices
		switch_gun()
		print(global_position, 'gulugul')
		
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
	
	jump_squeeze.stretch()
	screenFlash.screen_flash(Color.RED, 0.08, 0.09)
	cameraRef.trigger_shake(5, 15)
	
	var hostileDirection = hostile_dir_manager.hostileDir
	if hostileDirection != null:
		print(str(directionToObject(hostileDirection), 'groot'))
		knockback(Vector2(directionToObject(hostileDirection) * -1, 0), damageAmount * 6)
	
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
	
	if not gun.is_connected("ammoChange", trackAmmo) or gun.is_connected("shotFired", shotFiredFun):
		gun.connect("ammoChange", trackAmmo)
	
	if not gun.is_connected("shotFired", shotFiredFun):
		gun.shotFired.connect(shotFiredFun)
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


func shotFiredFun():
	screenFlash.screen_flash(Color.WHITE, 0.04, 0.1)


func directionToObject(object_pos: Vector2) -> float:
	if object_pos:
		return global_position.direction_to(object_pos).x
	else:
		return 0.0


func knockback(dir: Vector2, force: float):
	# Add knockback in direction
	kb_velocity += dir.normalized() * force
	kb_velocity.y = force * 0.35
	kb_velocity = kb_velocity.limit_length(350)
