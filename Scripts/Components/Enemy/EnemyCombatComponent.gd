class_name EnemyMeleeCombatComponent extends Node

signal is_attacking(speed: float, target: Player)

var min_damage: int
var max_damage: int
var attack_speed: float
var anim: String
var stat_ref: Dictionary = {}
var main_stat_value: int
var cant_attack = true

@export var scale_percent: float =  0.05

func apply_melee_weapon_data(data: EnemyWeaponResource) -> void:
	if data == null or not is_instance_valid(data):
		push_warning("EnemyMeleeCombatComponent: No Data Found")
		return
		
	min_damage = data.min_damage
	max_damage = data.max_damage
	attack_speed = data.attack_speed
	anim = data.attack_animation

func enemy_calculate_weapon_damage(base_damage: int, defense: int, is_mainhand: bool = true) -> int:
	main_stat_value = stat_ref[StatConst.STATS.STRENGTH]
	
	var bonus_damage: float = main_stat_value * scale_percent
	
	var total_damage: float = base_damage + bonus_damage
	
	# Apply defense (simple flat reduction)
	total_damage = base_damage * (1.0 + main_stat_value * scale_percent)
	
	return max(1, round(total_damage))


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
	var cal_damage: int = enemy_calculate_weapon_damage(randi_range(min_damage, max_damage), defense.armor, true)
	if health.has_method("take_damage"):
		health.take_damage(cal_damage)

func _on_weapon_shield_relic_enemy_hit(body: Player) -> void:
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
	var cal_damage: int = enemy_calculate_weapon_damage(randi_range(min_damage, max_damage), defense.armor, true)
	if health.has_method("take_damage"):
		health.take_damage(cal_damage)

func _on_enemy_health_component_dead() -> void:
	cant_attack = true

func _on_enemy_stats_compoment_current_stats(dic: Dictionary, _a: int, ms: int) -> void:
	stat_ref = dic
