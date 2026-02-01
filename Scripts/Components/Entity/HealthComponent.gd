@icon("uid://b2rmumt45lw3m")
class_name HealthComponent extends Node

signal dead
signal is_hurt(status: bool)
signal revived(status: bool)
signal current_helth(amount: int)

@export var out_health_bar: ProgressBar

@export var max_health: int = 100
@export var hp_per_vit: int = 5
var health: int = 100
var vitality: int = 10
var is_dead: bool = false

func _ready() -> void:
	if is_dead:
		return
	if not out_health_bar:
		push_warning("HealthComponent: Missing health bar export.")
		return

func take_damage(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	_update_hp_bar(health)
	emit_signal("is_hurt", true)
	
	if health == 0:
		health = 0
		is_dead = true
		emit_signal("dead")
	
func _update_hp_bar(current_health: int) -> void:
	if out_health_bar:
		out_health_bar.value = current_health
		emit_signal("current_helth",current_health)

func _revive_player(amount_percetage: float) -> void:
	health += int(max_health * amount_percetage)
	emit_signal("revived", true)
