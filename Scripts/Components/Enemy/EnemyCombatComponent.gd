class_name EnemyMeleeCombatComponent extends Node

signal is_attacking(speed: float, target: Player)

var min_damage: int
var max_damage: int
var attack_speed: float
var anim: String

var cant_attack = true

@export var stat_comp: StatComponent

func apply_melee_weapon_data(data: EnemyWeaponResource) -> void:
	if data == null or not is_instance_valid(data):
		push_warning("EnemyMeleeCombatComponent: No Data Found")
		return
		
	min_damage = data.min_damage
	max_damage = data.max_damage
	attack_speed = data.attack_speed
	anim = data.attack_animation

func _on_enemy_main_hand_component_enemy_hit(body: Player) -> void:
	if not body.is_in_group("player"):
		return
	if not cant_attack:
		return
	var health: Node= body.get_node("HealthComponent") as HealthComponent
	var defense: Node = body.get_node("StatComponent") as StatComponent
	if health == null:
		push_warning("Enemy hit player but no HealthComponent found")
		return
	if defense == null:
		push_warning("Enemy hit player but no StatComponent found")
		return
	var cal_damage: int = stat_comp.calculate_weapon_damage(randi_range(min_damage, max_damage), defense.armor, true)
	if health.has_method("take_damage"):
		health.take_damage(cal_damage)


func _on_weapon_shield_relic_enemy_hit(body: Player) -> void:
	pass # Replace with function body.


func _on_enemy_health_component_dead() -> void:
	cant_attack = true
