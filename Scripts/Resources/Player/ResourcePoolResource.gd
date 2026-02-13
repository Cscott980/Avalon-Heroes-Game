class_name ResourcePoolResource extends Resource

enum ResourceType {
	MANA,
	RAGE,
	ENERGY,
	SCRAP,
	EXP_GEM
}

@export_group("Settings")
@export var resource_type: ResourceType
@export var name: String = "Mana"
@export var color: Color = Color.DODGER_BLUE #UI Bar

@export_group("Values")
@export var max_value: int = 100
@export var start_value: int
@export var regen_rate: float = 0.5 #per second
@export var regen_delay: float = 0.0 #delay after spending

@export_group("Properties")
@export_flags(
	"On Hit", 
	"On Kill", 
	"On Take Damage", 
	"Out of Combat"
	) var gain_conditions: int = 0
