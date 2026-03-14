@icon("uid://cffg7pusi6jd0")
class_name TargetsInRangeComponent extends Node3D

signal target_change(new_target: CharacterBody3D)
signal target_in_range

@export var player: CharacterBody3D
@export var move_comp: MovementComponent

@export var attack_stop_distance: float = 1.1

var current_target: CharacterBody3D = null

var pending_click_attack: bool = false
var manual_target_locked: bool = false

func _physics_process(_delta: float) -> void:
	if current_target == null or not is_instance_valid(current_target):
		return
	
	if current_target.is_in_group("dead_enemies"):
		clear_manual_target()
		return
	
	if not manual_target_locked:
		return
	
	var dist := get_distance_to_current_target()

	if dist > attack_stop_distance:
		move_comp.set_move_to_target(current_target.global_position)
	else:
		move_comp.stop_click_move()
		
		if pending_click_attack:
			pending_click_attack = false
			target_in_range.emit()

func get_closest_target() -> CharacterBody3D:
	return current_target

func get_distance_to_current_target() -> float:
	if current_target == null or not is_instance_valid(current_target):
		return INF
	return player.global_position.distance_to(current_target.global_position)

func get_direction_to_current_target() -> Vector3:
	if current_target == null or not is_instance_valid(current_target):
		return Vector3.ZERO
	return (current_target.global_position - player.global_position).normalized()

func clear_manual_target() -> void:
	if current_target != null and is_instance_valid(current_target):
		if current_target.has_node("EnemyVisualComponent"):
			var old_visual := current_target.get_node("EnemyVisualComponent") as EnemyVisualComponent
			old_visual.highlighter_off()
	
	manual_target_locked = false
	pending_click_attack = false
	current_target = null
	move_comp.stop_click_move()
	target_change.emit(null)

func get_best_click_target(click_pos: Vector3, max_dist: float = 2.5) -> Enemy:
	var best: Enemy = null
	var best_dist := INF

	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.is_in_group("dead_enemies"):
			continue
		
		var d: float = enemy.global_position.distance_to(click_pos)
		if d < max_dist and d < best_dist:
			best_dist = d
			best = enemy as Enemy

	return best

func get_best_close_target(click_pos: Vector3, player_pos: Vector3, click_radius: float = 2.5, player_radius: float = 3.0) -> Enemy:
	var best: Enemy = null
	var best_score := INF

	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.is_in_group("dead_enemies"):
			continue
		
		var click_dist: float = enemy.global_position.distance_to(click_pos)
		var player_dist: float = enemy.global_position.distance_to(player_pos)

		if click_dist > click_radius:
			continue
		if player_dist > player_radius:
			continue

		var score := click_dist + player_dist * 0.5
		if score < best_score:
			best_score = score
			best = enemy as Enemy

	return best

func _on_player_input_component_attack_target_requested(target: Enemy) -> void:
	if target == null or not is_instance_valid(target):
		return
		
	if current_target == target:
		pending_click_attack = true
		return
		
	if current_target != null and is_instance_valid(current_target):
		if current_target.has_node("EnemyVisualComponent"):
			var old_visual := current_target.get_node("EnemyVisualComponent") as EnemyVisualComponent
			old_visual.highlighter_off()
	
	current_target = target
	manual_target_locked = true
	pending_click_attack = true
	
	if current_target.has_node("EnemyVisualComponent"):
		var new_visual := current_target.get_node("EnemyVisualComponent") as EnemyVisualComponent
		new_visual.highlighter_on()
	
	target_change.emit(current_target)

func _on_player_input_component_ground_move_requested(_data: Dictionary) -> void:
	clear_manual_target()

func _on_player_input_component_move_intent_changed(intent: Vector3) -> void:
	if intent.length() > 0.1:
		clear_manual_target()
