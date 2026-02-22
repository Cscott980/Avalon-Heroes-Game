@icon("uid://b6vioyh5wceoi")
class_name HealthComponent extends Node

signal dead
signal hurt
signal revived(owner: Node)
signal current_health(amount: int, max_player_health: int)

@export var value_display: ValueEmitterComponent

@export var max_health: int = 100
@export var hp_per_vit_percentage: int = 0.05

var health: int 
var vitality: int
var is_dead: bool = false

func apply_player_health_data(amount: int, stats: StatResource) -> void:
	vitality = stats.vitality
	max_health = amount
	cal_vit_point()
	health = max_health
	print(max_health)
	print(health)
	current_health.emit(health, max_health)

func cal_vit_point() -> void:
	max_health += (vitality * hp_per_vit_percentage)

func _on_player_healed(amount_percetage: float) -> void:
	health += int(max_health * amount_percetage)
	current_health.emit(health)

func on_revive(amount_percetage: float) -> void:
	health += int(max_health * amount_percetage)
	is_dead = false
	revived.emit(true)

func take_damage(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	value_display.create_indicator_label(amount, 1)
	current_health.emit(health, max_health)
	hurt.emit()
	
	if health <= 0:
		health = 0
		is_dead = true
		dead.emit()
