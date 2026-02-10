extends Node

@export var maxHealth: float
@export var isInvincible: bool = false
var currentHealth: float

signal hasTakenDamage(damageAmount: float, attackerRef: CharacterBody2D)
signal hasDied

func _ready():
	currentHealth = maxHealth

func takeDamage(damageAmount: float, attackerRef = null):
	if currentHealth <= 0 or isInvincible:
		return
	
	currentHealth -= damageAmount
	print(currentHealth)
	emit_signal("hasTakenDamage", damageAmount, attackerRef)
	
	if currentHealth <= 0:
		emit_signal("hasDied")

func procureHealth(healthIncrease: float):
	if currentHealth >= maxHealth:
		return
	
	currentHealth += healthIncrease
	
	if currentHealth >= maxHealth:
		currentHealth = maxHealth
