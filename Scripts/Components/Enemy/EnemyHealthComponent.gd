class_name EnemyHealthComponent extends Node

signal hit(current_amount: int)
signal current_health(current_amount: int)
signal dead
signal revived


var is_dead: bool = false 

@export var max_health: int = 100
var health: int
var vitality: int
var hp_per_bit: int = 2


func apply_health_data(new_health: int, stats: StatResource) -> void:
	max_health = new_health
	health = max_health
	vitality = stats.vitality
	current_health.emit(health)

func take_damage(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	hit.emit(health)
	
	if health <= 0:
		health = 0
		is_dead = true
		dead.emit()
		current_health.emit(health)


func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area.is_in_group("player_weapon") or area.is_in_group("player_projectile"):
		var dmg = area.get("damage")
		if dmg != null:
			take_damage(dmg)


func _on_status_effect_component_dot(damage: int) -> void:
	pass # Replace with function body.
