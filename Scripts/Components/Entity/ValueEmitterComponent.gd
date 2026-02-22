class_name ValueEmitterComponent extends Node3D

const INDICATOR_LABEL = preload("uid://bx1vs3j0rpyrj")

@export var font_size: int = 50
@export var label_range: float = 2.0
@export var anim_duration: int = 2

func create_indicator_label(value:int, type:int) -> void:
	var indicatorlabel = INDICATOR_LABEL.instantiate() as DamageIndicator
	get_tree().current_scene.add_child(indicatorlabel)
	indicatorlabel.global_position = global_position
	
	indicatorlabel.set_value(value, type)
	_tween_indicator(indicatorlabel)
	
func _tween_indicator(label: Node3D) -> void:
	var tween = create_tween()
	var random_target_position = Vector3(
		randf_range(-label_range, label_range),
		randf_range(0, label_range),
		randf_range(-label_range, label_range)
	)
	
	tween.tween_property(label, "position", label.global_position + random_target_position, anim_duration)
	
	tween.tween_callback(label.queue_free)
