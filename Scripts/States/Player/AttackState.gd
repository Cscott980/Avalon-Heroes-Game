extends PlayerState
class_name Attack_State_1

var attack_data: AttackDataResource
var combo: Array[AttackDataResource]
var no_weapon_equiped: bool
var dual_wielding: bool = false
var weapon_data: WeaponResource

func enter() -> void:
	print("ENTER Attack_State_1")
	if no_weapon_equiped:
		return
	combo = combat_comp.get_current_weapon_combo()
	if combo.is_empty() or combo.size() < 1:
		return
	attack_data = combo[0]
	
	player.lunge_component.lunge(attack_data)
	
	combat_comp.base_melee_attack_started(0)
	
	if not dual_wielding:
		playback.play_attack_animation(attack_data.animation_name, weapon_data.weapon_speed)
	else:
		playback.play_attack_animation(attack_data.dualwield_animation_name, weapon_data.weapon_speed)
	
	var speed: float = max(weapon_data.weapon_speed, 0.01)
	get_tree().create_timer(attack_data.combo_window_start / speed).timeout.connect(_open_combo_window)
	get_tree().create_timer(attack_data.combo_window_end / speed).timeout.connect(_close_combo_window)
	

func _open_combo_window() -> void:
	combat_comp.open_combo_window()

func _close_combo_window() -> void:
	combat_comp.close_combo_window()

func _finish_attack() -> void:
	combat_comp.close_combo_window()
	combat_comp.base_melee_complete_attack()

func exit() -> void:
	pass

func _on_main_hand_weapon_no_weapon_equiped(status: bool) -> void:
	no_weapon_equiped = status

func _on_weapon_equip_component_is_dual_wielding(status: bool) -> void:
	dual_wielding = status

func _on_main_hand_weapon_weapon_data(data: WeaponResource, _group: String) -> void:
	weapon_data = data
