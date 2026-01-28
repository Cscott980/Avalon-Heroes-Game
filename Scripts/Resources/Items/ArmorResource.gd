class_name ArmorResource extends ItemResource

enum ArmorType {Light, Medium, Heavy, Shield}
@export var armor_slot_type: EquipmentSlotResource
@export var armor_type: ArmorType
@export var armor_exclusive_to: String #This is only for ItemPanel

@export_group("Accessory Mesh")
@export var mesh_accessory: Mesh

@export_group("Back Mesh")
@export var mesh_back: Mesh

@export_group("Helm Mesh")
@export var mesh_helm: Mesh
@export var mesh_helm_addon: Mesh

@export_group("Armor Mesh Set")
@export var mesh_arm_left: Mesh
@export var mesh_arm_right: Mesh
@export var mesh_armor: Mesh
@export var mesh_leg_left: Mesh
@export var mesh_leg_right: Mesh

@export_group("Shield")
@export var shield: Mesh

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
