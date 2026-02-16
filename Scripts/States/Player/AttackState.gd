extends PlayerState
class_name Attack_State_1

var lunge_timer: float = 0.0
var is_lunging: bool = false
var lunge_direction: Vector3 = Vector3.ZERO
var attack_data: AttackDataResource
var combo: Array[AttackDataResource]
func enter() -> void:
	combat_comp.get_current_weapon_combo()
	if combo.is_empty() or combo.size() < 1:
		return
	attack_data = combo[0]
	
	combat_comp.base_melee_attack_started(0)
	
	if not player.weapon_equip_component.is_dual_wielding:
		playback.play_attack_animation(attack_data.animation_name)
	else:
		playback.play_attack_animation(attack_data.dualwield_animation_name)
	
	_setup_lunge()
	get_tree().create_timer(attack_data.combo_window_start).timeout.connect(_open_combo_window)
	get_tree().create_timer(attack_data.attack_duration).timeout.connect(_finish_attack)
	
func _setup_lunge() -> void:
	if not attack_data.lunge_to_target:
		return
	var weapon_type = player.weapon_equip_component.main_hand_weapon.WEAPON_TYPE
	if weapon_type == null:
		return
	
	if weapon_type.attack_type == WeaponResource.ATTCK_TYPE.RANGED:
		return
	
	var target_distance = player.targets_in_range_component.get_direction_to_current_target()
	
	if lunge_direction != Vector3.ZERO:
		var target_rotation = atan2(lunge_direction.x, lunge_direction.z)
		player.movement_component.model.y = target_rotation

func _open_combo_window() -> void:
	combat_comp.open_combo_window()

func _finish_attack() -> void:
	combat_comp.close_combo_window()
	combat_comp.complete_attack()
	
func exit() -> void:
	is_lunging = false
	lunge_timer = 0.0
	
func _ready() -> void:
	pass
	
func physics_process(delta: float) -> void:
	if is_lunging and lunge_timer > 0:
		lunge_timer -= delta
		player.velocity = lunge_direction * attack_data.lunge_speed
		player.move_and_slide()
		
		if lunge_timer <= 0:
			is_lunging = false
	elif attack_data.root_motion_speed > 0:
		player.velocity = player.transform.basis.z * attack_data.root_motion_speed
		player.move_and_slide()
	else:
		if not player.is_on_floor():
			player.velocity.y -= 9.8 * delta
			player.move_and_slide()
