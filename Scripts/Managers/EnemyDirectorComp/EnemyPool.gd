class_name EnemyPool extends Node


@export var enemy_base_scene: PackedScene


@export var enemies: Dictionary = {
	&"grunt": [],
	&"elite": []
}


var pools: Dictionary = {}

func _ready() -> void:
	_build_pool_keys()

func _build_pool_keys() -> void:
	for tier in enemies.keys():
		var list: Array = enemies[tier]
		for res in list:
			if res == null:
				continue
			var id := _get_id(res)
			if not pools.has(id):
				pools[id] = []

func pick_resource(tier: StringName) -> EnemyResource:
	var list: Array = enemies.get(tier, [])
	if list.is_empty():
		return null
	return list[randi() % list.size()]

func take(res: EnemyResource) -> Enemy:
	if res == null:
		return null

	var id := _get_id(res)
	if not pools.has(id):
		pools[id] = []

	var arr: Array = pools[id]
	var enemy: Enemy

	if arr.size() > 0:
		enemy = arr.pop_back()
	else:
		enemy = enemy_base_scene.instantiate() as Enemy

	enemy.visible = true
	enemy.process_mode = Node.PROCESS_MODE_INHERIT
	enemy.reset_for_pool()

	
	enemy.pool_key = id

	return enemy

func release(res: EnemyResource, enemy: Enemy) -> void:
	if enemy == null or res == null:
		return

	var id := _get_id(res)
	if not pools.has(id):
		pools[id] = []

	if enemy.get_parent():
		enemy.get_parent().remove_child(enemy)

	enemy.reset_for_pool()
	enemy.visible = false
	enemy.process_mode = Node.PROCESS_MODE_DISABLED

	var arr: Array = pools[id]
	arr.append(enemy)

func _get_id(res: EnemyResource) -> StringName:
	if res == null:
		return &""
	if res.has_meta("enemy_id"):
		return StringName(res.get_meta("enemy_id"))
	return StringName(res.resource_path)
