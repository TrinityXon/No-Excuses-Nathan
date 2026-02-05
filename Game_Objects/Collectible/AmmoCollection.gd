extends Area2D

@export var ammoIncreaseMin: int = 1
@export var ammoIncreaseMax: int = 5

@onready var pickup = $Pickup
@onready var pickup_sound = $PickupSound
@onready var sprite = $Ammo

var ammoIncreaseAmount

func _ready():
	ammoIncreaseAmount = randi_range(ammoIncreaseMin, ammoIncreaseMax)

		
func pickedFinish():
	pickup_sound.play()
	sprite.visible = false
	pickup.process_mode = Node.PROCESS_MODE_DISABLED
	print('heyyyeye')
	await pickup_sound.finished
	queue_free()

func pickupLogic(body):
	var gun = body.allguns[body.selectedGun]
	
	if gun and gun.has_method("increaseAmmoCount"):
		gun.increaseAmmoCount(ammoIncreaseAmount)
		print(ammoIncreaseAmount)
		pickedFinish()

func _on_pickup_has_picked(body):
	pickupLogic(body)
