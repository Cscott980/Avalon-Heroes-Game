class_name CharacterSheetDisplay extends Node3D

@onready var arm_left: MeshInstance3D = $Rig_Medium/Skeleton3D/arm_left
@onready var arm_right: MeshInstance3D = $Rig_Medium/Skeleton3D/arm_right
@onready var helm: MeshInstance3D = $Rig_Medium/Skeleton3D/helm
@onready var helm_addon: MeshInstance3D = $Rig_Medium/Skeleton3D/helm_addon
@onready var armor: MeshInstance3D = $Rig_Medium/Skeleton3D/armor
@onready var head: MeshInstance3D = $Rig_Medium/Skeleton3D/head
@onready var leg_left: MeshInstance3D = $Rig_Medium/Skeleton3D/leg_left
@onready var leg_right: MeshInstance3D = $Rig_Medium/Skeleton3D/leg_right
@onready var accessory_1: MeshInstance3D = $Rig_Medium/Skeleton3D/accessory1
@onready var accessory_2: MeshInstance3D = $Rig_Medium/Skeleton3D/accessory2
@onready var accessory_3: MeshInstance3D = $Rig_Medium/Skeleton3D/accessory3
@onready var mh: MeshInstance3D = $Rig_Medium/Skeleton3D/MainHand/mesh
@onready var oh: MeshInstance3D = $Rig_Medium/Skeleton3D/OffHand/mesh
@onready var back: MeshInstance3D = $Rig_Medium/Skeleton3D/back

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var anim_state: AnimationNodeStateMachinePlayback = (animation_tree.get("parameters/IdleStates/playback"))

@export var data: EquipmentandInventory
var vs_defults: HeroClassVisualDefaultResource
var armor_visulas_list: Array[MeshInstance3D] 
var weapons_visuals_list: Array[MeshInstance3D]

func _ready() -> void:
	await  get_tree().process_frame
	vs_defults = data.vs_data.get("defults")
	anim_state.travel("Idle")

	if head != null:
		head.mesh = head.mesh 
		head.skin = head.skin
		head.material_override = head.material_override
	else:
		head.mesh = null
		head.skim = null

func armor_visual_updater(a: ArmorResource) -> void:
	if a == null:
		armor.mesh = vs_defults.armor
		arm_left.mesh = vs_defults.left_arm
		arm_right.mesh = vs_defults.right_arm
		leg_left.mesh = vs_defults.left_leg
		leg_right.mesh = vs_defults.right_leg
		
		armor.skin = vs_defults.skin
		arm_left.skin = vs_defults.skin
		arm_right.skin = vs_defults.skin
		leg_left.skin = vs_defults.skin
		leg_right.skin = vs_defults.skin
		return
		
	armor.mesh = a.armor
	arm_left.mesh = a.arm_left
	arm_right.mesh = a.arm_right
	leg_left.mesh = a.leg_left
	leg_right.mesh = a.leg_right
	
	armor.skin = a.skin
	arm_left.skin = a.skin
	arm_right.skin = a.skin
	leg_left.skin = a.skin
	leg_right.skin = a.skin

func apply_equipment(slot_res: EquipmentSlotResource, item: ItemResource, sub_index: int = -1, hand: StringName = &"main") -> void:
	match slot_res.equipment_slot_type:
		EquipmentSlotResource.SlotType.Helm:
			var a := item as ArmorResource
			helm.mesh = a.helm if a else null
			helm_addon.mesh = a.helm_addon if a else null
			helm.skin = a.skin if a else null
			helm_addon.skin = a.skin if a else null
				
		EquipmentSlotResource.SlotType.Armor:
			armor_visual_updater(item as ArmorResource)
		
		EquipmentSlotResource.SlotType.Back:
			var b := item as ArmorResource
			back.mesh = b.back if b else null
			back.skin = b.skin if b else null
		
		EquipmentSlotResource.SlotType.Accessory:
			var a := item as ArmorResource
			var target = [accessory_1, accessory_2, accessory_3][sub_index]
			target.mesh = a.accessory if a else null
			target.skin = a.skin if a else null
		
		EquipmentSlotResource.SlotType.Weapon:
			var w = item as WeaponResource
			if hand == &"off":
				oh.mesh = w.mesh if w else null
				if w != null:
					if w.handedness == WeaponResource.HANDEDNESS.ONE_HANDED:
						anim_state.travel("Idle")
			else:
				mh.mesh = w.mesh if w else null
				if w != null:
					if w.handedness == WeaponResource.HANDEDNESS.TWO_HANDED:
						anim_state.travel("2HandIdle")
					elif w.handedness == WeaponResource.HANDEDNESS.ONE_HANDED:
						anim_state.travel("Idle")
					elif w.weapon_type == "Bow":
						anim_state.travel("BowIdle")
				else:
					return
