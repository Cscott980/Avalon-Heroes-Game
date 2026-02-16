@icon("uid://bqnuvlrnctll4")
class_name WeaponEquipComponent extends Node

signal is_dual_wielding(status: bool)

@export var main_hand_weapon: WeaponComponent
@export var off_hand_weapon:WeaponComponent
@export var range_weapon: RangeWeaponComponent
@export var shield: ShieldComponent

var main_hand_data: WeaponResource
var off_hand_data: WeaponResource
var dual_wielding: bool = false
func _ready() -> void:
	pass

func update_dual_wielding_state() -> void:
	if main_hand_weapon == null or off_hand_weapon == null:
		dual_wielding = false
		is_dual_wielding.emit(false)
		return
		
	if main_hand_weapon.WEAPON_TYPE == null or off_hand_weapon.WEAPON_TYPE == null:
		dual_wielding = false
		is_dual_wielding.emit(false)
		return
	
	var mh := main_hand_weapon.WEAPON_TYPE
	var oh := off_hand_weapon.WEAPON_TYPE
	
	if mh == null or oh == null:
		dual_wielding = false
		is_dual_wielding.emit(false)
		return
	if mh.handedness != WeaponResource.HANDEDNESS.ONE_HANDED:
		dual_wielding = false
		is_dual_wielding.emit(false)
		return
	if oh.handedness != WeaponResource.HANDEDNESS.ONE_HANDED:
		dual_wielding = false
		is_dual_wielding.emit(false)
		return
	if oh.weapon_type == ArmorResource.ArmorType.Shield:
		dual_wielding = false
		is_dual_wielding.emit(false)
		return
	print("here i am")
	dual_wielding = true
	is_dual_wielding.emit(true)
