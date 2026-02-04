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
	if not is_instance_valid(user):
		if user is Player:
			user = user as Player
		elif user is Enemy:
			user = user as Enemy
		else: 
			#Later I can add Bosses.
			return
	if is_dead:
		return
	if not out_health_bar:
		push_warning("HealthComponent: Missing health bar export.")
		return

func _on_hit_box_component_take_damage(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	GameSignals.emit_signal("current_health", user.multiplayer_id, health )
	
	if health == 0:
		health = 0
		is_dead = true
		emit_signal("dead")
	


func _revive_player(amount_percetage: float) -> void:
	health += int(max_health * amount_percetage)
	emit_signal("revived", true)

func _on_hurt_box_take_damage(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	_update_hp_bar(health)
	emit_signal("current_health", health)
	emit_signal("is_hurt", true)
	
	if health == 0:
		health = 0
		is_dead = true
		emit_signal("dead")
