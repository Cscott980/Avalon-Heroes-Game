class_name PlayerEquipmentResource extends Resource


@export_group("Armor")
@export var helm: ArmorResource
@export var armor: ArmorResource
@export var back: ArmorResource

@export_group("Accessory")
@export var accessory1: ArmorResource
@export var accessory2: ArmorResource
@export var accessory3: ArmorResource

@export_group("Weapons and Relics")
@export var main_hand: WeaponResource
@export var off_hand: WeaponResource
@export var shield: ArmorResource


func set_item(slot_res: EquipmentSlotResource, item: ItemResource, hand_role: StringName = &"main", accessory_index: int = -1) -> ItemResource:
	var old: ItemResource = null
	
	match slot_res.equipment_slot_type:
		EquipmentSlotResource.SlotType.Helm:
			old = helm
			helm = item as ArmorResource
			
		EquipmentSlotResource.SlotType.Armor:
			old = armor
			armor = item as ArmorResource
			
		EquipmentSlotResource.SlotType.Back:
			old = back
			back = item as ArmorResource
			
		EquipmentSlotResource.SlotType.Accessory:
			match accessory_index:
				0:
					old = accessory1
					accessory1 = item
				1:
					old = accessory2
					accessory2 = item
				2:
					old = accessory3
					accessory3 = item
		EquipmentSlotResource.SlotType.Weapon:
			if hand_role == &"off":
				old = off_hand
				off_hand = item as WeaponResource
			else:
				old = main_hand
				main_hand = item as WeaponResource
	return old

func remove_item(slot_res: EquipmentSlotResource, item: ItemResource, hand_role: StringName = &"main", accessory_index: int = -1) -> ItemResource:
	return set_item(slot_res, null, hand_role, accessory_index)
