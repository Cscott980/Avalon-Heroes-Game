class_name EnemySpawnComponent extends Node

signal spawned
signal spawn

func _ready() -> void:
	spawn.emit()
	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"Spawn":
		spawned.emit()
