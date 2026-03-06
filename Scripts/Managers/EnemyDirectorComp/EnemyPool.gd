class_name EnemyPool extends Node

@export var enemy_base_scene: PackedScene

@export var enemies: Array[EnemyResource] = []

func pick_resource(list: Array) -> EnemyResource:
	if list.is_empty():
		return null
	return list[randi() % list.size()]

func make_enemy() -> Enemy:
	var base = enemy_base_scene.instantiate() as Enemy
	return base
