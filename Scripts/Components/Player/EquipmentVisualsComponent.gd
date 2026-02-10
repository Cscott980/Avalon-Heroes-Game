@icon("uid://dlmhywsisedbf")
class_name EquipmentVisualComponent extends Node

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

func apply_defults() ->void:
	pass

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
