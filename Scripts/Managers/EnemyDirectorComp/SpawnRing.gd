class_name SpawnRing extends Node

const INVALID_POS := Vector3.INF

@export var inner_radius: float = 12.0
@export var outer_radius: float = 18.0
@export var players: Array[Player] = []


func _ready() -> void:
	players.clear()

	for n in get_tree().get_nodes_in_group("players"):
		if n is Player:
			players.append(n)

func get_spawn_offset() -> Vector3:
	var angle := randf_range(0.0, TAU)
	var t := randf()
	var r := sqrt(lerp(inner_radius * inner_radius, outer_radius * outer_radius, t))
	return Vector3(cos(angle) * r, 0.0, sin(angle) * r)

func get_random_alive_player() -> Player:
	var alive := players.filter(func(p): return is_instance_valid(p) and not p.is_in_group("dead_players"))
	if alive.is_empty():
		return null
	return alive.pick_random()

func get_spawn_position() -> Vector3:
	var p := get_random_alive_player()
	if p == null:
		return INVALID_POS
	return p.global_position + get_spawn_offset()
