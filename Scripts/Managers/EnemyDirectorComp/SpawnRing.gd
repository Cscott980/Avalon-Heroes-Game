class_name SpawnRing extends Node

@export var inner_radius: float = 12.0
@export var outer_radius: float = 18.0
@export var players: Array[Player] = []

func get_spawn_offset() -> Vector3:
	var angle := randf_range(0.0, TAU)
	var t := randf()
	var r := sqrt(lerp(inner_radius * inner_radius, outer_radius * outer_radius, t))
	return Vector3(cos(angle) * r, 0.0, sin(angle) * r)

func get_random_alive_player() -> Player:
	var alive := players.filter(func(p): return is_instance_valid(p) and not p.is_queued_for_deletion())
	if alive.is_empty():
		return null
	return alive.pick_random()

func get_spawn_position() -> Vector3:
	var p := get_random_alive_player()
	if p == null:
		return Vector3.ZERO
	return p.global_position + get_spawn_offset()
