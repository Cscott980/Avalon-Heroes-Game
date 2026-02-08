@icon("uid://ciq5gabr211ay")
class_name CombatComponent extends Node

@export var melee_main_hand_comp: WeaponComponent
@export var melee_off_hand_comp: WeaponComponent
#@export var range_weapon_component: RangeWeaponComponent
@export var shield_comp: ShieldComponent
@export var ability_comp: AbilityComponent


var damage_data: Dictionary = {}

var damage: int
var attack_speed: float
var can_attack:bool
