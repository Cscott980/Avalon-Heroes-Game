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
	if body.is_in_group("player"):
		var do_dmg = body.get_node("HealthComponent") as HealthComponent
		if do_dmg.has_method("take_damage"):
			do_dmg.take_damge(min_damage)
