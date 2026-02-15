@icon("uid://bqnuvlrnctll4")
class_name WeaponEquipComponent extends Node

signal is_dual_wielding(status: bool)

@export var main_hand_weapon: WeaponComponent
@export var off_hand_weapon:WeaponComponent
@export var range_weapon: RangeWeaponComponent
@export var shield: ShieldComponent

var main_hand_data: WeaponResource
var off_hand_data: WeaponResource

func _ready() -> void:
	pass

func update_dual_wielding_state() -> void:
	if main_hand_weapon == null or off_hand_weapon == null:
		is_dual_wielding.emit(false)
		return
		
	if main_hand_weapon.WEAPON_TYPE == null or off_hand_weapon.WEAPON_TYPE == null:
		is_dual_wielding.emit(false)
		return
	
	var mh := main_hand_weapon.WEAPON_TYPE
	var oh := off_hand_weapon.WEAPON_TYPE
	
	if mh == null or oh == null:
		is_dual_wielding.emit(false)
		return
	if mh.handedness != WeaponResource.HANDEDNESS.ONE_HANDED:
		is_dual_wielding.emit(false)
		return
	if oh.handedness != WeaponResource.HANDEDNESS.ONE_HANDED:
		is_dual_wielding.emit(false)
		return
	if oh.weapon_type == ArmorResource.ArmorType.Shield:
		is_dual_wielding.emit(false)
		return
	print("here i am")
	is_dual_wielding.emit(true)
