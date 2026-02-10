extends Node2D

@onready var raycast = %RayCast2D
@export var damage: float
@export var range: float = 600

@export var animation: AnimationPlayer
@onready var muzzleFlash = %EffectManager
@export var ammoMax: float
var ammoCnt: float
@export var infiniteAmmo: bool

enum gunStates {REGULAR, SHOTGUN}

@export var curGunState: gunStates = gunStates.REGULAR

var canShoot = true
@onready var shotTimer = $ShotTimer
@onready var shootEffect = %PistolMFlash

@export var shotAnim: String
@onready var shootSound: Node2D = $SoundEffect

@onready var gunshot_sound = $Gunshot_sound
@onready var cameraRef = get_tree().get_first_node_in_group('Camera')
@onready var flash_effect = get_tree().get_first_node_in_group('ScreenFlash')


var emitBus: Node

signal ammoChange(curAmmo: float)
signal shotFired

func _ready():
	raycast.target_position = Vector2(0, range)
	ammoCnt = ammoMax
	
	emitBus = get_node("EmitBus")

func shoot():
	if not canShoot:
		return
	
	if ammoCnt > 0:
		if not infiniteAmmo:
			decreaseAmmoCount(1)
		
		if animation.has_animation(shotAnim):
			animation.play(shotAnim)
			if muzzleFlash: muzzleFlash.playEffect()
		
		match curGunState:
			gunStates.REGULAR:
				shootRegular()
			gunStates.SHOTGUN:
				shootShotgun()

	else:
		print("yes")
	
	canShoot = false
	shotTimer.start()


func _on_shot_timer_timeout():
	canShoot = true

func increaseAmmoCount(increase: float):
	if ammoCnt > ammoMax:
		return
	
	ammoCnt += increase
	if ammoCnt > ammoMax:
		ammoCnt = ammoMax
	
	print(increase)
	ammoChange.emit(ammoCnt)
	
func decreaseAmmoCount(decrease: float):
	if ammoCnt <= 0:
		return
	
	ammoCnt -= decrease

	if ammoCnt < 0:
		ammoCnt = 0
	
	ammoChange.emit(ammoCnt)

func shootRegular():
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		
		if hit and hit.has_node("healthMonitor"):
			var damageCollider = hit.get_node("healthMonitor")
			damageCollider.takeDamage(damage)
			print(hit.name)
	
	gunshot_sound.play()
		
	shotFired.emit()
	shootEffect.visible = true
	shootEffect.play_animation()
	await shootEffect.animation_finished
	
	shootEffect.visible = false
	
func shootShotgun():
	pass # TODO: ADD SPRAY MECHANICS
	
