@icon("uid://bqnuvlrnctll4")
class_name WeaponEquipComponent extends Node

signal weapon_is_sheathed(status: bool)
signal is_dual_wielding(status: bool)
@export var main_hand_weapon: WeaponComponent
@export var off_hand_weapon:WeaponComponent
@export var range_weapon: RangeWeaponComponent
@export var shield: ShieldComponent

func _ready() -> void:
	weapon_is_sheathed.emit(false)

func update_dual_wielding_state() -> void:
	
	var mh := main_hand_weapon.WEAPON_TYPE
	var oh := off_hand_weapon.WEAPON_TYPE
	
	if mh == null or oh == null:
		emit_signal("is_dual_wielding", false)
	
	if mh.handedness != WeaponResource.HANDEDNESS.ONE_HANDED:
		emit_signal("is_dual_wielding", false)
	if oh.handedness != WeaponResource.HANDEDNESS.ONE_HANDED:
		emit_signal("is_dual_wielding", false)
	if oh.weapon_type == ArmorResource.ArmorType.Shield:
		emit_signal("is_dual_wielding", false)
	
	emit_signal("is_dual_wielding", true)
