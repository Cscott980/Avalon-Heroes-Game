@icon("uid://b6vioyh5wceoi")
class_name HealthComponent extends Node

signal dead
signal hurt
signal revived(owner: Node)
signal current_health(amount: int, max_player_health: int)

@export var player: Player
@export var value_display: ValueEmitterComponent
@export var drop_pickup_comp: DropPickUpComponent
@export var camera: CameraEffect

@export var max_health: int = 100
@export var hp_per_vit_percentage: float = 0.05
@export var percentage_health_mod: float

var health: int 
var vitality: int
var is_dead: bool = false

func apply_player_health_data(amount: int, stats: StatResource) -> void:
	vitality = stats.vitality
	max_health = amount
	health = max_health
	current_health.emit(health, max_health)

func cal_vit_point() -> void:
	max_health += int(vitality * hp_per_vit_percentage)

func _on_player_healed(amount_percetage: float) -> void:
	if health >= max_health:
		health = max_health
		return
	var heal_amount: int = int(max_health * amount_percetage)
	health += heal_amount
	value_display.create_indicator_label(heal_amount, DamageTypesConstants.TYPES.HEAL)
	current_health.emit(health, max_health)

func on_revive(amount_percetage: float) -> void:
	health += int(max_health * amount_percetage)
	is_dead = false
	revived.emit(true)

func take_damage(amount: int) -> void:
	if is_dead:
		return
	if player.immortal:
		return
		
	health -= amount
	value_display.create_indicator_label(amount, 1)
	current_health.emit(health, max_health)
	hurt.emit()
	camera.shake(0.25)
	
	if health <= 0:
		health = 0
		is_dead = true
		dead.emit()
		camera.shake(0.35)

func _on_drop_pickup_component_health_potion(amount: float) -> void:
	var heal_amount: int = int(max_health * amount)
	health += heal_amount
	value_display.create_indicator_label(heal_amount, DamageTypesConstants.TYPES.HEAL)
	current_health.emit(health, max_health)

func _on_progression_component_level(_current_level: int) -> void:
	if _current_level == 1:
		return
	max_health += int(max_health * 0.1)
	health = max_health
	current_health.emit(health, max_health)

func _on_stat_component_current_stats(dic: Dictionary) -> void:
	vitality = dic.get(StatConstants.STATS.VITALITY, vitality)
	cal_vit_point()
