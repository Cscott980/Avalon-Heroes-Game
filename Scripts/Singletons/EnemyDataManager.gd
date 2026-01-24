class_name EnemyDataManager extends Node

enum ENEMY_TYPE {SKELETAL_GRUNT, SKELETAL_RANGER, SKELETAL_WARRIOR, SKELETAL_NECRO, ORC_GRUNT, ORC_HUNTER, ORC_WARRIOR}

var enum_to_string: Dictionary = {
	ENEMY_TYPE.SKELETAL_GRUNT: "enemy_skeletal_grunt",
	ENEMY_TYPE.SKELETAL_RANGER: "enemy_skeletal_ranger",
	ENEMY_TYPE.SKELETAL_WARRIOR: "enemy_skeletal_warrior",
	ENEMY_TYPE.SKELETAL_NECRO: "enemy_skeletal_necromancer",
	ENEMY_TYPE.ORC_GRUNT: "enemy_orc_grunt",
	ENEMY_TYPE.ORC_HUNTER: "enemy_orc_hunter",
	ENEMY_TYPE.ORC_WARRIOR: "enemy_orc",
}

var enemy_data_base: Dictionary = {}

func _ready() -> void:
	enemy_data_base = GameData.enemies.get("enemies", {})

func get_enemy(enemy: String) -> String:
	var enemy_to_spawn = enemy_data_base.get(enemy, {})
	var enemy_scene = enemy_to_spawn.get("scene_path", "")
	return enemy_scene

func load_enemy_id(enemy_picked: int) -> String:
	return enum_to_string.get(enemy_picked, "")
