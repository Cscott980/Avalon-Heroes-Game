@icon("uid://3goakyntjrgr")
class_name TargetingComponent extends Node


signal targets_close(status: bool)
signal new_target(target: CharacterBody3D)

@export var user: CharacterBody3D
@export var attack_range: float

var targets: Array[Node]
var current_target: CharacterBody3D


func _ready() -> void:
	await  get_tree().process_frame
	_set_new_target()

func apply_targeting_data(range_of_attack: float) -> void:
	attack_range = range_of_attack

func _set_new_target() -> void:
	targets = get_tree().get_nodes_in_group("player")
	var closest = null
	var best_dis: float = INF
	
	for p in targets: 
		if p == null or !is_instance_valid(p):
			continue
		var d := user.global_position.distance_to(p.global_position)
		if d < best_dis:
			best_dis = d
			closest = p
	current_target = closest
	new_target.emit(current_target)

func target_in_range() -> bool:
	if current_target == null or !is_instance_valid(current_target):
		return false
	return user.global_position.distance_to(current_target.global_position) <= attack_range

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		targets_close.emit(true)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		targets_close.emit(false)
