@icon("uid://dlmhywsisedbf")
class_name EquipmentVisualComponent extends Node

signal weapon_sheathed
signal weapon_unsheathed


@export_group("Components")
@export var main_hand_weapon: WeaponComponent
@export var off_hand_weapon: WeaponComponent 
@export var shield: ShieldComponent 

@export_group("Slots")
@export var main_hand_slot: BoneAttachment3D
@export var off_hand_slot: BoneAttachment3D
@export var sheath_back: BoneAttachment3D
@export var sheath_hip_right: BoneAttachment3D
@export var sheath_hip_left: BoneAttachment3D

@export_group("Meshes")
@export var arm_left: MeshInstance3D
@export var arm_right: MeshInstance3D
@export var helm: MeshInstance3D
@export var helm_addon: MeshInstance3D
@export var armor: MeshInstance3D
@export var back: MeshInstance3D
@export var head: MeshInstance3D
@export var leg_left: MeshInstance3D
@export var leg_right: MeshInstance3D
@export var accessory_1: MeshInstance3D
@export var accessory_2: MeshInstance3D
@export var accessory_3: MeshInstance3D

var class_defults: HeroClassVisualDefaultResource
var player_equipment: PlayerEquipmentResource

var is_sheathed: bool

func apply_defults() ->void:
	pass
	
func sheeth_weapon() -> void:
	if main_hand_weapon.WEAPON_TYPE == null and off_hand_weapon.WEAPON_TYPE == null: 
		return
		
	var mh := main_hand_weapon.WEAPON_TYPE
	var oh := off_hand_weapon.WEAPON_TYPE
	
	var use_hips := false
	if mh != null and mh.handedness == WeaponResource.HANDEDNESS.ONE_HANDED:
		use_hips = true
	#if oh != null and oh.handedness == WeaponResource.HANDEDNESS.ONE_HANDED and oh.weapon_type != "Shield":
		use_hips = true
	
	if use_hips:
		if mh != null and main_hand_weapon.get_parent() == main_hand_slot:
			main_hand_slot.remove_child(main_hand_weapon)
			sheath_hip_left.add_child(main_hand_weapon)
			main_hand_slot.transform = Transform3D.IDENTITY
			main_hand_weapon.mesh.transform = main_hand_weapon.left_hip_sheath.transform
		if oh != null and off_hand_weapon.get_parent() == off_hand_slot:
			off_hand_slot.remove_child(off_hand_weapon)
			sheath_hip_right.add_child(off_hand_weapon)
			off_hand_slot.transform = Transform3D.IDENTITY
			off_hand_weapon.mesh.transform = off_hand_weapon.right_hip_sheath.transform
	else:
		if mh != null and main_hand_weapon.get_parent() == main_hand_slot:
			main_hand_slot.remove_child(main_hand_weapon)
			sheath_back.add_child(main_hand_weapon)
			main_hand_slot.transform = Transform3D.IDENTITY
			main_hand_weapon.mesh.transform = main_hand_weapon.back_sheath.transform
		#if oh != null and off_hand_weapon.get_parent() == off_hand_slot and oh.weapon_type == "Shield":
			sheath_back.add_child(off_hand_weapon)
			off_hand_slot.transform = Transform3D.IDENTITY
			off_hand_weapon.mesh.transform = main_hand_weapon.back_sheath.transform
			
	weapon_sheathed.emit()

func unsheeth_weapon() -> void:
	if main_hand_weapon.WEAPON_TYPE != null and main_hand_weapon.get_parent() != main_hand_slot:
		main_hand_weapon.get_parent().remove_child(main_hand_weapon)
		main_hand_slot.add_child(main_hand_weapon)
		main_hand_slot.transform = Transform3D.IDENTITY
		main_hand_weapon.mesh.transform = main_hand_weapon.weapon_defult_position
	if off_hand_weapon.WEAPON_TYPE != null and off_hand_weapon.get_parent() != off_hand_slot:
		off_hand_weapon.get_parent().remove_child(off_hand_weapon)
		off_hand_slot.add_child(off_hand_weapon)
		off_hand_slot.transform = Transform3D.IDENTITY
		off_hand_weapon.mesh.transform = off_hand_weapon.weapon_defult_position
		
	weapon_unsheathed.emit()

func apply_equipment(slot_res: EquipmentSlotResource, item: ItemResource, sub_index: int = -1, hand: StringName = &"main"):
	match slot_res.equipment_slot_type:
		EquipmentSlotResource.SlotType.Helm:
			var a := item as ArmorResource
			helm.mesh = a.helm if a != null else null
			helm.skin = a.skin if a != null else null
			helm_addon.mesh = a.helm_addon if a != null else null
			helm_addon.skin = a.skin if a != null else null
		EquipmentSlotResource.SlotType.Armor:
			var a := item as ArmorResource
			arm_left.mesh = a.arm_left if a != null else null
			arm_left.skin = a.skin if a != null else null
			arm_right.mesh = a.arm_right if a != null else null
			arm_right.skin = a.skin if a != null else null
			armor.mesh = a.armor if a != null else null
			armor.skin = a.skin if a != null else null
			leg_left.mesh = a.leg_left if a != null else null
			leg_left.skin = a.skin if a != null else null
			leg_right.mesh = a.leg_right if a != null else null
			leg_right.skin = a.skin if a != null else null
		EquipmentSlotResource.SlotType.Accessory:
			var a := item as ArmorResource
			var target: MeshInstance3D = null
			match sub_index:
				0: target = accessory_1
				1: target = accessory_2
				2: target = accessory_3
			if target != null:
				target.mesh = a.accessory if a != null else null
				target.skin = a.skin if a != null else null
			
		EquipmentSlotResource.SlotType.Weapon:
			if item == null:
				if hand == &"off":
					off_hand_weapon.clear_weapon()
				else:
					main_hand_weapon.clear_weapon()
				return
				
			var w:= item as WeaponResource
			if w == null:
				return
				
			if hand == &"off":
				var mh := main_hand_weapon.WEAPON_TYPE
				if mh != null and mh.handedness == WeaponResource.HANDEDNESS.TWO_HANDED:
					main_hand_weapon.clear_weapon()
				off_hand_weapon.load_weapon(w)
			else:
				if w != null and w.handedness == WeaponResource.HANDEDNESS.TWO_HANDED:
					off_hand_weapon.clear_weapon()
				main_hand_weapon.load_weapon(w)


func _on_player_input_component_sheath_weapon(sheath: bool) -> void:
	if sheath:
		unsheeth_weapon()
	else:
		sheeth_weapon()
