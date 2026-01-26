class_name AbilityResource extends Resource

enum AbilityType {
	ACTIVE,
	PASSIVE,
	ULTIMATE
}
enum ScaleOn{
	STRENGTH,
	INTELLECT,
	DEXTERITY,
	WISDOM
}

@export_group("Info")
@export var display_name: String = ""
@export_multiline var description: String

@export_group("Visuals")
@export var active_icon: Texture2D
@export var pressed_icon:Texture2D
@export var disabled_icon: Texture2D
@export var ability_type: AbilityType = AbilityType.ACTIVE
@export var vfx: PackedScene

@export_group("Properties")
@export var level_to_unlock: int = 10
@export var base_damage: int
@export var scale_on_stat: ScaleOn
@export var status_effect: StatusEffectsResource
@export var duration:float
@export var dist_meters: float
@export var radial_metters: float
