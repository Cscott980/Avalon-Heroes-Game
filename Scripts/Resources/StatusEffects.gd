class_name StatusEffectsResource extends Resource


@export var id: String
@export var display_name: String
@export_multiline var description: String
@export var icon: Texture2D

@export_enum("buff", "debuff", "dot", "hot", "cc")
var effect_type: String = "buff"

@export var duration: float = 0.0
@export var tick_interval: float = 1.0
@export var max_stacks: int = 1
@export var refresh_on_reapply: bool = true
