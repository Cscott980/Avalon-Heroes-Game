@icon("uid://bqnuvlrnctll4")
class_name WeaponEquipComponent extends Node

signal is_dual_wielding(status: bool)

var dual_wielding: bool = false

func update_dual_wielding_state(mainhand: WeaponResource, offhand: WeaponResource) -> void:		
	if mainhand == null or offhand == null:
		print("I am null")
		dual_wielding = false
		is_dual_wielding.emit(false)
		return
	
	var mh: WeaponResource = mainhand if mainhand != null else null
	var oh: WeaponResource = offhand if offhand != null else null
	
	if mh == null or oh == null:
		print("mh or oh are null")
		dual_wielding = false
		is_dual_wielding.emit(false)
		return
	if mh.handedness != WeaponResource.HANDEDNESS.ONE_HANDED:
		print("wrong handeness for main hand")
		dual_wielding = false
		is_dual_wielding.emit(false)
		return
	if oh.handedness != WeaponResource.HANDEDNESS.ONE_HANDED:
		print("wrong handeness for offhand")
		dual_wielding = false
		is_dual_wielding.emit(false)
		return
	if oh.weapon_type == ArmorResource.ArmorType.Shield:
		print("I am a shield")
		dual_wielding = false
		is_dual_wielding.emit(false)
		return
	
	dual_wielding = true
	print("Dualwielding is %s" %dual_wielding)
	is_dual_wielding.emit(true)
