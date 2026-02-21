class_name EnemyMeleeCombatComponent extends Node

signal is_attacking(speed: float, target: Player)

var min_damage: int
var max_damage: int
var attack_speed: float
var anim: String


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
		
	var health := body.get_node_or_null("HealthComponent") as HealthComponent
	if health == null:
		push_warning("Enemy hit player but no HealthComponent found")
		return
	
	var cal_damage := randi_range(min_damage, max_damage)
	health.take_damage(cal_damage)
