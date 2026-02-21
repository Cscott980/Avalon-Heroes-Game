@icon("uid://cffg7pusi6jd0")
class_name TargetsInRangeComponent extends Node

signal target_change(new_target: CharacterBody3D)
signal targets_updated(count: int)

@onready var detector: Area3D = %TargetsInRange
@export var player: CharacterBody3D

var targets_in_range: Array[CharacterBody3D] = []
var current_target: CharacterBody3D

func _ready() -> void:
	pass

func get_closets_target() -> CharacterBody3D:
	print(current_target)
	return current_target

func get_distance_to_current_target() -> float:
	if current_target == null or not is_instance_valid(current_target):
		return INF
	return player.global_position.distance_to(current_target.global_position)

func get_direction_to_current_target() -> Vector3:
	if current_target == null or not is_instance_valid(current_target):
		return Vector3.ZERO
	return (current_target.global_position - player.global_position).normalized()

func _update_closest_target() -> void:
	for i in range(targets_in_range.size() -1, -1, -1):
		var e := targets_in_range[i]
		if e == null or not is_instance_valid(e) or e.is_in_group("dead_enemies"):
			targets_in_range.remove_at(i)
		
	var closest: Node3D = null
	var closest_dist_sq := INF
	
	for e in targets_in_range:
		var d_sq := player.global_position.distance_squared_to(e.global_position)
		if d_sq < closest_dist_sq:
			closest_dist_sq = d_sq
			closest = e
	if closest == current_target:
		return
		
	if current_target != null and is_instance_valid(current_target):
		if current_target.has_node("EnemyVisualComponent"):
			var highlighter = current_target.get_node("EnemyVisualComponent") as EnemyVisualComponent
			highlighter.highlighter_off()
	
	current_target = closest
	
	if current_target != null:
		if current_target.has_node("EnemyVisualComponent"):
			var highlighter = current_target.get_node("EnemyVisualComponent") as EnemyVisualComponent
			highlighter.highlighter_on()
	
	for e in targets_in_range:
		if e == null or not is_instance_valid(e) or e.is_in_group("dead_enemies"):
			if e.has_node("EnemyVisualComponent"):
				var highlighter = e.get_node("EnemyVisualComponent") as EnemyVisualComponent
				highlighter.highlighter_off()
	get_direction_to_current_target()
	get_distance_to_current_target()

func _on_targets_in_range_body_entered(body: Node3D) -> void:
	if not body.is_in_group("enemy") or body.is_in_group("dead_enemies"):
		return
	
	if not targets_in_range.has(body):
		targets_in_range.append(body)
		
	_update_closest_target()

func _on_targets_in_range_body_exited(body: Node3D) -> void:
	if targets_in_range.has(body):
		targets_in_range.erase(body)
	_update_closest_target()
