class_name StatusEffectsResource extends Resource

enum EffectType {
	BUFF,
	DEBUFF,
	DOT,
	HOT,
	CC
}



@export var effect_type: EffectType
@export var display_name: String
@export_multiline var description: String
@export var icon: Texture2D

@export_group("Properties")
@export var duration: float = 0.0
@export var damage_per_second: int = 0
@export var heal_per_second: int = 0
@export var tick_interval: float = 1.0
@export var max_stacks: int = 1
@export var refresh_on_reapply: bool = true

@export_group("Multipliers")
@export var stat_to_mod: StatConst.STATS
@export var stat_mod_value: float
@export var damage_mod: float # modifier by percentage base
