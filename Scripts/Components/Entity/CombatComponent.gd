@icon("uid://ciq5gabr211ay")
class_name CombatComponent extends Node

signal attack_started(attack_index: int)
signal attack_hit(target: Node, damage: float)
signal combo_broken
signal combo_completed
signal combo_window_open
signal combo_window_closed
signal attack_window_ended

@onready var attack_cooldown: Timer = %AttackCooldown
@onready var combo_timer: Timer = %ComboTimer

@export var weapon_equip_comp: WeaponEquipComponent


var current_combo_idx: int = 0
var combo_timeout: float = 1.0
var can_combo: bool = false
var is_attacking: bool = false
var attack_queued: bool = false

var main_hand_data: WeaponResource
var off_hand_data: WeaponResource

var stat: StatComponent

func _ready() -> void:
	combo_timer.wait_time = combo_timeout
	combo_timer.one_shot = true

func get_current_weapon_combo() -> Array[AttackDataResource]:
	if main_hand_data == null:
		return []
	
	var weapon = main_hand_data.attack_combo
	if weapon == null:
		return []
	return weapon

func request_attack() -> int:
	var combo_data = get_current_weapon_combo()
	
	if combo_data.is_empty():
		return -1
	
	if is_attacking and not can_combo:
		attack_queued = true
		return -1
	
	if current_combo_idx >= combo_data.size():
		return -1
	
	return current_combo_idx

func base_melee_attack_started(index: int) -> void:
	var combo_data = get_current_weapon_combo()
	
	if combo_data.is_empty() or index >= combo_data.size():
		return
	
	current_combo_idx = index
	is_attacking = true
	can_combo = false
	attack_queued = false
	
	if combo_timer.is_stopped():
		combo_timer.stop()
		
	attack_started.emit(index)

func open_combo_window() -> void:
	can_combo = true
	combo_window_open.emit()
	
	if attack_queued:
		attack_queued = false
		combo_window_open.emit()

func close_combo_window() -> void:
	can_combo = false
	combo_window_closed.emit()

func base_melee_complete_attack() -> void:
	var combo_data = get_current_weapon_combo()
	
	is_attacking = false
	attack_window_ended.emit()
	
	if current_combo_idx >= combo_data.size() -1:
		combo_completed.emit()
		reset_combo()
	else:
		current_combo_idx += 1
		combo_timer.start(combo_timeout)

func reset_combo() -> void:
	current_combo_idx = 0
	is_attacking = false
	can_combo = false
	attack_queued = false
	if not combo_timer.is_stopped():
		combo_timer.stop()
	combo_broken.emit()

func _on_attack_cooldown_timeout() -> void:
	is_attacking = false

func _on_combo_timer_timeout() -> void:
	if not is_attacking:
		reset_combo()

func _on_off_hand_weapon_weapon_hit(target: Node3D) -> void:
	# Handle off-hand attacks if dual wielding
	attack_hit.emit(target, 0)

func _on_main_hand_weapon_weapon_hit(target: Node3D) -> void:
	var combo_data = get_current_weapon_combo()
	if combo_data.is_empty():
		return
	if target.is_in_group("enemy"):
		var damage = main_hand_data.damage
		var do_dmg = target.get_node("EnemyHealthComponent") as EnemyHealthComponent
		if do_dmg.has_method("take_damage"):
			do_dmg.take_damage(damage)

func _on_main_hand_weapon_weapon_data(data: WeaponResource, _group: String) -> void:
	main_hand_data = data

func _on_off_hand_weapon_weapon_data(data: WeaponResource, _group: String) -> void:
	off_hand_data = data
