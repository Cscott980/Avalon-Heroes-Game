class_name EnemyDropComponent extends Node3D

var guaranteeed: Array = []
var chance: Array = []

func apply_drop_data(sure_drop: Array[PackedScene], chance_drop: Array[PackedScene]) -> void:
	guaranteeed = sure_drop
	chance = chance_drop

func _drop() -> void:
	for g_drop in guaranteeed:
		var g_item = g_drop.instantiate() as Drop
		var world = get_tree().current_scene
		world.add_child(g_item)
		g_item.global_position = global_position
	
	if not chance.is_empty():
		var item = chance[randi_range(0,chance.size() -1)].instantiate()
		var world = get_tree().current_scene
		world.add_child(item)
		item.global_position = global_position

func _on_enemy_health_component_dead() -> void:
	_drop()
