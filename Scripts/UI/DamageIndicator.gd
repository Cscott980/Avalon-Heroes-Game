class_name DamageIndicator extends Node3D

@onready var indicator: Label = $Sprite3D/SubViewport/DamageHealingCrit

func set_value(value: int, value_type: int) -> void:
	indicator.text = str(value)
	indicator.add_theme_color_override("font_color",ValueTypeConst.load_type_color(value_type))
