class_name SpawnRing
extends Node

@export var inner_radius: float = 12.0
@export var outer_radius: float = 18.0
@export var players: Array[Player] = []

func _ready() -> void:
	if players.is_empty():
		return
	refresh_players()

func refresh_players() -> void:
	players.clear()

	for n in get_tree().get_nodes_in_group("player"):
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
	if players.is_empty():
		refresh_players()

	var p := get_random_alive_player()
	if p == null:
		push_error("SpawnRing: no alive player found")
		return Vector3.ZERO

	return p.global_position + get_spawn_offset()
