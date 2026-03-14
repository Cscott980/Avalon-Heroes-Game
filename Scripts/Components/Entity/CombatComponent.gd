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
@export var stat_comp: StatComponent
@export var player_cam: CameraEffect
@export var attack_cam_shake_strength: float = 0.12

var current_combo_idx: int = 0
var combo_timeout: float = 1.0
var can_combo: bool = false
var is_attacking: bool = false
var attack_queued: bool = false

var main_hand_data: WeaponResource
var off_hand_data: WeaponResource

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
	print("request_attack | idx=", current_combo_idx, " attacking=", is_attacking, " can_combo=", can_combo, " queued=", attack_queued)

	if combo_data.is_empty():
		print("request_attack -> no combo")
		return -1

	if is_attacking and not can_combo:
		attack_queued = true
		print("request_attack -> queued")
		return -1

	if is_attacking and can_combo:
		var next_idx := current_combo_idx + 1
		print("request_attack -> next idx ", next_idx)
		if next_idx >= combo_data.size():
			print("request_attack -> next idx too high")
			return -1
		return next_idx

	if current_combo_idx >= combo_data.size():
		print("request_attack -> current idx too high")
		return -1

	print("request_attack -> return current idx ", current_combo_idx)
	return current_combo_idx

func base_melee_attack_started(index: int) -> void:
	var combo_data = get_current_weapon_combo()

	if combo_data.is_empty() or index >= combo_data.size():
		print("base_melee_attack_started blocked")
		return

	current_combo_idx = index
	is_attacking = true
	can_combo = false
	attack_queued = false

	print("ATTACK STARTED idx=", index)

	attack_started.emit(index)
	
func open_combo_window() -> void:
	can_combo = true
	combo_window_open.emit()

func close_combo_window() -> void:
	can_combo = false
	combo_window_closed.emit()

func base_melee_complete_attack() -> void:
	var combo_data = get_current_weapon_combo()

	print("base_melee_complete_attack idx=", current_combo_idx)

	is_attacking = false
	attack_window_ended.emit()

	if current_combo_idx >= combo_data.size() - 1:
		print("combo completed -> reset")
		combo_completed.emit()
		reset_combo()
	else:
		current_combo_idx += 1
		print("combo advanced to ", current_combo_idx)
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

func _on_off_hand_weapon_weapon_hit(area: Area3D) -> void:
	var hurt_component = area.get_parent() as EnemyHurtBoxComponent
	var damage = stat_comp.calculate_weapon_damage(randi_range(off_hand_data.min_damage, off_hand_data.max_damage), hurt_component.armor, false)
	hurt_component.emit_signal("damage_recived", damage)
	player_cam.shake(attack_cam_shake_strength)

func _on_main_hand_weapon_weapon_hit(area: Area3D) -> void:
	var hurt_component = area.get_parent() as EnemyHurtBoxComponent
	var damage = stat_comp.calculate_weapon_damage(randi_range(main_hand_data.min_damage, main_hand_data.max_damage), hurt_component.armor, true)
	hurt_component.emit_signal("damage_recived", damage)
	player_cam.shake(attack_cam_shake_strength)

func _on_main_hand_weapon_weapon_data(data: WeaponResource, _group: String) -> void:
	main_hand_data = data

func _on_off_hand_weapon_weapon_data(data: WeaponResource, _group: String) -> void:
	off_hand_data = data
