@icon("uid://b6vioyh5wceoi")
class_name HealthComponent extends Node

signal dead(owner: Node)
signal hurt
signal revived(owner: Node)
signal current_health(amount: int)

@export var out_health_bar: ProgressBar
@export var max_health: int = 100
@export var hp_per_vit: int = 5

var health: int = 100
var vitality: int = 10
var is_dead: bool = false

func _ready() -> void:
	await  get_tree().process_frame
	print(str(health))
func _on_player_healed(amount_percetage: float) -> void:
	health += int(max_health * amount_percetage)
	current_health.emit(health)

func on_revive(amount_percetage: float) -> void:
	health += int(max_health * amount_percetage)
	emit_signal("revived", true)

func take_damge(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	current_health.emit(health)
	emit_signal("is_hurt", true)
	
	if health == 0:
		health = 0
		is_dead = true
		emit_signal("dead")

func _on_hurt_box_area_entered(_area: Area3D) -> void:
	hurt.emit()
