extends "res://Game_Objects/Enemies/Enemies.gd"

# Movement Variables
@export var gravity: float = 900
@export var speed = 300
@export var patrolSpeed = 150
@export var jumpValue = -450

# Vision cone visibility
@export var visionVisible: bool = true

# External node references
@export var player: CharacterBody2D
@export var activationZones: Area2D

# Jump checks
@onready var sideCheck_L: RayCast2D = %sideCheck_L # TODO - CHECK FOR LEDGES AND JUMP
@onready var sideCheck_R: RayCast2D = %sideCheck_R # SAME AS ABOVE

# Internal node references
@onready var gunParent: Node2D = $gunParent
@onready var enemySprite: Sprite2D = $Icon
@onready var detectionLabel = $Label
@onready var playerCheck = $PlayerCheck
@onready var idleTimer = $IdleTimer
@onready var enemyDetectRay = %HostileCheck
@onready var shotCheck = %ShotCheck
@onready var reactionTimer = %ReactionSpeed

# Vision cone reference
@onready var poly_gon = $PlayerCheck/CollisionPolygon2D

# Patrol points control
@export var travelPoints: Array[Marker2D]

# Enemy state handler
enum enemyStates {IDLE, PATROL, CHASE, ATTACK}
var currentState: enemyStates = enemyStates.IDLE

# Gun reference
var gun
var currentGunRange: float

# AI miscellaneous nodes
var hasDetected: bool = false
var isInAttackRange: bool = false
var moveDir: Vector2 = Vector2.RIGHT
var Index: int = 0

# IDK Why this is here but imma NOT touch it
@onready var visionCone: Area2D = $Vision

# Travel points vector array conversion
var TravelPointsVector: Array = []

# Detection toggles
@export var immediatelySeePlayer: bool = false
@export var usesVisionCone: bool = true
@export var usesActivationZones: bool = false

# Miscellaneous
var canStartTimer: bool = true

func _ready():
	gun = gunParent.get_child(0)
	currentGunRange = gun.range
	
	print(currentGunRange)
	
	shotCheck.target_position.x = currentGunRange
	
	print(shotCheck.target_position.x)
	enter_new_state(currentState)
	
	if activationZones and usesActivationZones:
		activationZones.hasEnteredZone.connect(activationLogic)
	
	print(visionCone)
	
	visionCone = get_node("Vision")
	
	if not usesVisionCone:
		visionCone.set_process(false)
		visionCone.set_physics_process(false)
		visionCone.visible = false 
	
	if immediatelySeePlayer:
		visionVisible = false
		hasDetected = true
		currentState = enemyStates.CHASE
	
	if visionVisible:
		visionCone.visible = true
	else:
		visionCone.visible = false
	
		
	for points in travelPoints:
		TravelPointsVector.append(Vector2(round(points.global_position.x), round(points.global_position.y)))
	
func _physics_process(delta):
	flip_enemy()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if hasDetected:
		if isInAttackRange and castToCombatant(player):
			changeState(enemyStates.ATTACK)
		else:
			changeState(enemyStates.CHASE)
		
	if sideCheck_L.is_colliding() and moveDir != Vector2.ZERO and is_on_floor():
		jump(delta)
	
	if sideCheck_R.is_colliding() and moveDir != Vector2.ZERO and is_on_floor():
		jump(delta)
	
	manage_states()

	move_and_slide()

func _process(delta):
	pass

func idle():
	if not immediatelySeePlayer:
		velocity.x = 0

func patrol(TravelPointsV: Array):
	
	if TravelPointsV.size() != 0:
		var Cur_Point = TravelPointsV[Index]
		var dir = (Cur_Point - global_position).normalized()
		velocity.x = dir.x * patrolSpeed
		moveDir = Vector2(sign(velocity.x), 0)
	
	
		if abs(global_position.x - Cur_Point.x) < 5:
			if Index + 1 >= TravelPointsV.size():
				changeState(enemyStates.IDLE)
				Index = 0
				print("hello")
			else:
				changeState(enemyStates.IDLE)
				Index += 1
				print("bye")
		
	return

func chasePlayer():
	detectionLabel.text = '!'
	moveDir = (player.global_position - global_position).normalized()
	velocity.x = moveDir.x * speed
	print(moveDir.x)

func AttackPlayer():
	print('attack initiated')
	if hasClearShot():
		moveDir.x = 0
		velocity.x = 0
		print('clear shot')
	else:
		print('No clear shot')
	if gun.has_method("shoot") and hasClearShot():
		if canStartTimer:
			reactionTimer.start()
			canStartTimer = false
	else:
		reactionTimer.stop()
		canStartTimer = true
		
func _on_reaction_speed_timeout():
	print("can shoot")
	gun.shoot()
	canStartTimer = true

func _on_attack_distance_body_entered(body):
	if body == player:
		isInAttackRange = true

func _on_attack_distance_body_exited(body):
	if body == player:
		isInAttackRange = false

func hasClearShot() -> bool:
	if shotCheck.is_colliding():
		var hit = shotCheck.get_collider()
		if hit == player: 
			return true 
	
	return false

func flip_enemy():
	if moveDir == null:
		return
	
	if moveDir.x != 0:
		gunParent.scale.x = sign(moveDir.x)
		if visionCone:
			visionCone.scale.x = sign(moveDir.x)
		if moveDir.x < 0: enemySprite.flip_h = true
		if moveDir.x > 0: enemySprite.flip_h = false

func detection(body): 
	if not usesVisionCone:
		hasDetected = true
		detectionLabel.text = "!"

func manage_states():
	match currentState:
		enemyStates.IDLE:
			idle()
			#print("idling")
		enemyStates.PATROL:
			patrol(TravelPointsVector)
			#print("patrolling")
		enemyStates.ATTACK:
			AttackPlayer()
			#print("Attacking")
		enemyStates.CHASE:
			chasePlayer()
			#print("chasing")

func changeState(newState):
	if currentState == newState:
		return
	
	currentState = newState
	enter_new_state(newState)

func enter_new_state(state_cur): 
	match state_cur: 
		enemyStates.IDLE: 
			idleTimer.start()

func _on_idle_timer_timeout():
	changeState(enemyStates.PATROL)

func jump(delta: float):
	velocity.y += jumpValue * delta * 100

func castToCombatant(target: CharacterBody2D) -> bool:
	var direction = target.global_position - global_position
	enemyDetectRay.target_position = direction
	
	if enemyDetectRay.is_colliding():
		print("Located")
		return enemyDetectRay.get_collider() == target
	else:
		print("Not located")
		return false

func activationLogic():
	hasDetected = true
	
func _on_vision_has_detected():
	hasDetected = true
	print("Detected")

func _on_damage_behaviour():
	hasDetected = true
