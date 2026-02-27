class_name ItemDropResource extends Resource

enum DROP_TYPE {
	EXP_GEM,
	HEALTH_POT,
	MANA_POT,
	SCRAP
}

@export_group("Type")
@export var drop_type: DROP_TYPE
@export var drop_name: String

@export_group("Visuals")
@export var mesh: Mesh

@export_group("Properties")
@export var resource_type: ResourcePoolResource.ResourceType
@export var resource_amount: int
@export_flags(
	"warrior",
	"mage",
	"paladin",
	"range",
	"rogue",
	"druid",
	"engineer"
) var can_be_seen_by: int = 0
