class_name ArmorResource extends ItemResource

enum ArmorType {Light, Medium, Heavy, Shield}
@export var armor_slot_type: EquipmentSlotResource
@export var armor_type: ArmorType
@export var armor_exclusive_to: String #This is only for ItemPanel

@export_group("Accessory Mesh")
@export var accessory: Mesh

@export_group("Back Mesh")
@export var back: Mesh

@export_group("Helm Mesh")
@export var helm: Mesh
@export var helm_addon: Mesh

@export_group("Armor Mesh Set")
@export var arm_left: Mesh
@export var arm_right: Mesh
@export var armor: Mesh
@export var leg_left: Mesh
@export var leg_right: Mesh

@export_group("Shield")
@export var shield: Mesh
@export var shield_block_value: int
@export var shield_cooldown: int

@export_group("Skin")
@export var skin: Skin

@export_group("Properties")
@export var stat_bonus: StatBonusResource
@export_flags(
	"warrior",
	"paladin",
	"mage",
	"ranger",
	"rogue",
	"druid",
	"engineer"
) var allowed_classes = 0



func get_item_kind() -> String:
	return "armor"
