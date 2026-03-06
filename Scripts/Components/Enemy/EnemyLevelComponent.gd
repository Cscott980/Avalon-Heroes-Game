class_name EnemyLevelComponent extends Node

signal current_level(data: int)

@export var level: int

func set_level(l: int) -> void:
	level = l
	
func emit_level() -> void:
	current_level.emit(level)
