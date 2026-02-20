class_name EnemySpawnComponent extends Node

signal spawned
signal spawn

func _ready() -> void:
	spawn.emit()
	await get_tree().create_timer(3.5667).timeout
	spawned.emit()
	
