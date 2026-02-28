class_name EnemyDropComponent extends Node3D

var guaranteeed: Array = []
var chance: Array = []

func apply_drop_data(sure_drop: Array[PackedScene], chance_drop: Array[PackedScene]) -> void:
	guaranteeed = sure_drop
	chance = chance_drop
