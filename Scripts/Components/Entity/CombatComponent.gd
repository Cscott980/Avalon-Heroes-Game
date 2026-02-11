@icon("uid://ciq5gabr211ay")
class_name CombatComponent extends Node

signal attack_window_ended
signal combo_window_open

@onready var attack_cooldown: Timer = %AttackCooldown
@onready var combo_timer: Timer = %ComboTimer

@export var melee_main_hand_comp: WeaponComponent
@export var melee_off_hand_comp: WeaponComponent
@export var range_weap_comp: RangeWeaponComponent
#@export var range_weapon_component: RangeWeaponComponent
@export var shield_comp: ShieldComponent
@export var ability_comp: AbilityComponent

func _ready() -> void:
	pass

func _on_attack_cooldown_timeout() -> void:
	pass # Replace with function body.


func _on_combo_timer_timeout() -> void:
	pass # Replace with function body.

func _on_off_hand_weapon_weapon_hit(target: Node3D) -> void:
	pass # Replace with function body.


func _on_main_hand_weapon_weapon_hit(target: Node3D) -> void:
	pass # Replace with function body.


func _on_player_input_component_attack_pressed() -> void:
	pass # Replace with function body.


func _on_stat_component_current_stats(dic: Dictionary) -> void:
	pass # Replace with function body.
