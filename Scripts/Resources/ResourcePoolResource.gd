class_name ResourcePoolResource extends Resource

enum ResourceType {
	MANA,
	RAGE,
	ENERGY,
	SCRAP
}

@export_group("Settings")
@export var name: String = "Mana"
@export var color: Color = Color.DODGER_BLUE #UI Bar

@export_group("Values")
@export var max_value: int = 100
@export var regen_rate: float = 0.5 #per second
@export var regen_delay: float = 0.0 #delay after spending

@export_group("Properties")
@export var gain_on_hit: bool = false
@export var gain_on_kill: bool = false
@export var gain_on_take_damage: bool = false
@export var gain_out_of_combat: bool = false
