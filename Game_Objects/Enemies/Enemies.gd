extends CharacterBody2D

# Node references (note the @onready used)
@onready var deathAnim = $AnimationPlayer
@onready var deathTimer = $Timer
@onready var healthBar = $HealthBar
@onready var healthMonitor = $healthMonitor

@export var effectManager: Node2D

@export var ammoInstance: Array[PackedScene]

signal damageBehaviour
signal deathBehaviour

func _ready():
	healthBar.max_value = healthMonitor.maxHealth
	
	print(healthMonitor.maxHealth)
	healthBar.value = healthMonitor.currentHealth
	healthBar.visible = false


func _on_health_monitor_has_died():
	deathBehaviour.emit()
	print("dead")


func _on_health_monitor_has_taken_damage(damageAmount: float):
	
	if not self:
		print("Not self")
		return
	healthBar.visible = true
	healthBar.max_value = healthMonitor.maxHealth
	healthBar.value = healthMonitor.currentHealth
	
	damageBehaviour.emit()

	effectManager.playEffect()

func die(sfxLength: float):
	deathAnim.play("death")
	velocity = Vector2(0,0)
	$CollisionShape2D.disabled = true

	
	await get_tree().create_timer(sfxLength).timeout
	
	var spawnIndex = randi_range(0, ammoInstance.size() - 1)
	
	if ammoInstance.size() > 0:
		var new_pickup = ammoInstance[spawnIndex].instantiate()
		new_pickup.position = position
		get_tree().current_scene.add_child(new_pickup)
		print(new_pickup.global_position)
	else:
		print("shiz")
	
	queue_free()
