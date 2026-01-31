@icon("uid://b2rmumt45lw3m")
class_name HealthComponent extends Node

#signal is_dead(status: bool)
#signal is_hurt(status: bool)
#signal revived(status: bool)


@export var target: CharacterBody3D = null
@export var stats: StatComponent = null
@export var out_health_bar: ProgressBar


var max_health: int = 100
var health: int = 100
var vitality: int = 10
var hp_per_vit: int = 5

func _ready() -> void:
	pass

func _update_hp_bar(current_health: int) -> void:
	pass
