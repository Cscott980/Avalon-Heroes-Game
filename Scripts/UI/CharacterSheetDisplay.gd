class_name CharacterSheetDisplay extends Node3D

@onready var mesh_arm_left: MeshInstance3D = $Rig_Medium/Skeleton3D/mesh_arm_left
@onready var mesh_arm_right: MeshInstance3D = $Rig_Medium/Skeleton3D/mesh_arm_right
@onready var mesh_helm: MeshInstance3D = $Rig_Medium/Skeleton3D/mesh_helm
@onready var mesh_helm_addon: MeshInstance3D = $Rig_Medium/Skeleton3D/mesh_helm_addon
@onready var mesh_armor: MeshInstance3D = $Rig_Medium/Skeleton3D/mesh_armor
@onready var mesh_head: MeshInstance3D = $Rig_Medium/Skeleton3D/mesh_head
@onready var mesh_leg_left: MeshInstance3D = $Rig_Medium/Skeleton3D/mesh_leg_left
@onready var mesh_leg_right: MeshInstance3D = $Rig_Medium/Skeleton3D/mesh_leg_right
@onready var mesh_accessory_1: MeshInstance3D = $Rig_Medium/Skeleton3D/mesh_accessory1
@onready var mesh_accessory_2: MeshInstance3D = $Rig_Medium/Skeleton3D/mesh_accessory2
@onready var mesh_accessory_3: MeshInstance3D = $Rig_Medium/Skeleton3D/mesh_accessory3
@onready var mesh_mh: MeshInstance3D = $Rig_Medium/Skeleton3D/MainHand/mesh
@onready var mesh_oh: MeshInstance3D = $Rig_Medium/Skeleton3D/OffHand/mesh
@onready var mesh_back: MeshInstance3D = $Rig_Medium/Skeleton3D/mesh_back

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var anim_state: AnimationNodeStateMachinePlayback = (animation_tree.get("parameters/IdleStates/playback"))


var armor_visulas_list: Array[MeshInstance3D] 
var weapons_visuals_list: Array[MeshInstance3D] 

var player: Player = null
func _ready() -> void:
	await  get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	anim_state.travel("Idle")

	if player.mesh_head != null:
		mesh_head.mesh = player.mesh_head.mesh 
		mesh_head.skin = player.mesh_head.skin
	else:
		mesh_head.mesh = null
		mesh_head.skim = null

func armor_visual_updater(a: ArmorResource) -> void:
	if a == null:
		mesh_armor.mesh = null
		mesh_arm_left.mesh = null
		mesh_arm_right.mesh = null
		mesh_leg_left.mesh = null
		mesh_leg_right.mesh = null
		return
		
	mesh_armor.mesh = a.mesh_armor
	mesh_arm_left.mesh = a.mesh_arm_left
	mesh_arm_right.mesh = a.mesh_arm_right
	mesh_leg_left.mesh = a.mesh_leg_left
	mesh_leg_right.mesh = a.mesh_leg_right
	
	mesh_armor.skin = a.skin
	mesh_arm_left.skin = a.skin
	mesh_arm_right.skin = a.skin
	mesh_leg_left.skin = a.skin
	mesh_leg_right.skin = a.skin

func apply_equipment(slot_res: EquipmentSlotResource, item: ItemResource, sub_index: int = -1, hand: StringName = &"main") -> void:
	match slot_res.equipment_slot_type:
		EquipmentSlotResource.SlotType.Helm:
			var a := item as ArmorResource
			mesh_helm.mesh = a.mesh_helm if a else null
			mesh_helm_addon.mesh = a.mesh_helm_addon if a else null
			mesh_helm.skin = a.skin if a else null
			mesh_helm_addon.skin = a.skin if a else null
				
		EquipmentSlotResource.SlotType.Armor:
			armor_visual_updater(item as ArmorResource)
		
		EquipmentSlotResource.SlotType.Back:
			var b := item as ArmorResource
			mesh_back.mesh = b.mesh_back if b else null
			mesh_back.skin = b.skin if b else null
		
		EquipmentSlotResource.SlotType.Accessory:
			var a := item as ArmorResource
			var target = [mesh_accessory_1, mesh_accessory_2, mesh_accessory_3][sub_index]
			target.mesh = a.mesh_accessory if a else null
			target.skin = a.skin if a else null
		
		EquipmentSlotResource.SlotType.Weapon:
			var w = item as WeaponResource
			if hand == &"off":
				mesh_oh.mesh = w.mesh if w else null
				if w != null:
					if w.handedness == WeaponResource.HANDEDNESS.ONE_HANDED:
						anim_state.travel("Idle")
			else:
				mesh_mh.mesh = w.mesh if w else null
				if w != null:
					if w.handedness == WeaponResource.HANDEDNESS.TWO_HANDED:
						anim_state.travel("2HandIdle")
					elif w.handedness == WeaponResource.HANDEDNESS.ONE_HANDED:
						anim_state.travel("Idle")
					elif w.weapon_type == "Bow":
						anim_state.travel("BowIdle")
				else:
					return
				
