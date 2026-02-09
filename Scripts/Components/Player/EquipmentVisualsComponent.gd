class_name EquipmentVisualComponent extends Node3D

@onready var main_hand_slot: BoneAttachment3D = %MainHand
@onready var off_hand_slot: BoneAttachment3D = %OffHand
@onready var main_hand_weapon: WeaponComponent = %MainHand/MainHandWeapon
@onready var off_hand_weapon: WeaponComponent = %OffHand/OffHandWeapon
@onready var shield: ShieldComponent = %OffHand/ShieldComponent

@onready var sheath_back: BoneAttachment3D = %SheathBack 
@onready var sheath_hip_right: BoneAttachment3D = %SheathHipRight 
@onready var sheath_hip_left: BoneAttachment3D = %SheathHipLeft 
@onready var mesh_arm_left: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_arm_left
@onready var mesh_arm_right: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_arm_right
@onready var mesh_helm: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_helm
@onready var mesh_helm_addon: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_helm_addon
@onready var mesh_armor: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_armor
@onready var mesh_head: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_head
@onready var mesh_leg_left: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_leg_left
@onready var mesh_leg_right: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_leg_right
@onready var mesh_accessory_1: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_accessory1
@onready var mesh_accessory_2: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_accessory2
@onready var mesh_accessory_3: MeshInstance3D = $Model/Rig_Medium/Skeleton3D/mesh_accessory3

var class_defults: HeroClassVisualDefaultResource
var player_equipment: PlayerEquipmentResource

func apply_equipment(slot_res: EquipmentSlotResource, item: ItemResource, sub_index: int = -1, hand: StringName = &"main"):
	match slot_res.equipment_slot_type:
		EquipmentSlotResource.SlotType.Helm:
			var a := item as ArmorResource
			mesh_helm.mesh = a.mesh_helm if a != null else null
			mesh_helm.skin = a.skin if a != null else null
			mesh_helm_addon.mesh = a.mesh_helm_addon if a != null else null
			mesh_helm_addon.skin = a.skin if a != null else null
		EquipmentSlotResource.SlotType.Armor:
			var a := item as ArmorResource
			mesh_arm_left.mesh = a.mesh_arm_left if a != null else null
			mesh_arm_left.skin = a.skin if a != null else null
			mesh_arm_right.mesh = a.mesh_arm_right if a != null else null
			mesh_arm_right.skin = a.skin if a != null else null
			mesh_armor.mesh = a.mesh_armor if a != null else null
			mesh_armor.skin = a.skin if a != null else null
			mesh_leg_left.mesh = a.mesh_leg_left if a != null else null
			mesh_leg_left.skin = a.skin if a != null else null
			mesh_leg_right.mesh = a.mesh_leg_right if a != null else null
			mesh_leg_right.skin = a.skin if a != null else null
		EquipmentSlotResource.SlotType.Accessory:
			var a := item as ArmorResource
			var target: MeshInstance3D = null
			match sub_index:
				0: target = mesh_accessory_1
				1: target = mesh_accessory_2
				2: target = mesh_accessory_3
			if target != null:
				target.mesh = a.mesh_accessory if a != null else null
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
