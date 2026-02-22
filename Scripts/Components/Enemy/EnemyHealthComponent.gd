class_name EnemyHealthComponent extends Node

signal hit(current_amount: int)
signal current_health(current_amount: int)
signal dead
signal revived


@export var value_display: ValueEmitterComponent
@export var max_health: int = 100

var is_dead: bool = false 
var health: int
var vitality: int
var hp_per_vit: int = 2


func apply_health_data(new_health: int, stats: StatResource) -> void:
	max_health = new_health
	health = max_health
	vitality = stats.vitality
	current_health.emit(health)

func take_damage(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	value_display.create_indicator_label(amount, 0)
	current_health.emit(health)
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

func _on_stat_component_current_stats(dic: Dictionary) -> void:
	max_health += (dic[StatConst.STATS.VITALITY] * hp_per_vit)
