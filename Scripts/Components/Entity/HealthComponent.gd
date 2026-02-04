@icon("uid://b2rmumt45lw3m")
class_name HealthComponent extends Node

signal dead(owner: Node)
signal revived(owner: Node)

@export var user: CharacterBody3D = null
@export var out_health_bar: ProgressBar
@export var max_health: int = 100
@export var hp_per_vit: int = 5

var health: int = 100
var vitality: int = 10
var is_dead: bool = false

func _ready() -> void:
	if not is_instance_valid(owner):
		return
	if is_dead:
		return
	if not out_health_bar:
		push_warning("HealthComponent: Missing health bar export.")
		return
	health = max_health
	
func _on_player_healed(amount_percetage: float) -> void:
	health += int(max_health * amount_percetage)
	GameSignals.emit_signal("current_health", user.multiplayer_id, health)

func on_revive(amount_percetage: float) -> void:
	health += int(max_health * amount_percetage)
	emit_signal("revived", true)

func _on_hurt_box_take_damage(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	GameSignals.emit_signal("current_health", user.multiplayer_id, health )
	emit_signal("is_hurt", true)
	
	if health == 0:
		health = 0
		is_dead = true
		emit_signal("dead")
