class_name AIControllerComponent extends Node

signal wandering
signal idling
signal target_in_attack_dist(status: bool)

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var user: CharacterBody3D
@export var model_base: Node3D
@export var speed: float
@export var turn_speed: float
@export var idling_wait_time: float = 5.0
@export var wander_radius: float
@export var wander_speed: float
@export var wander_reach_dist := 2.0

var current_target: CharacterBody3D = null

var can_move: bool = true
var is_dead: bool = false
var has_wander_point := false
var _is_wandering := false
var target_close: bool = false

var wander_wait:float = 0.0
var attack_range: float = 0.0

var knocked_back: bool = false

var wander_point: Vector3

func apply_movement_data(enemy_movement: EnemyMovementResource, weap_data: EnemyWeaponResource) -> void:
	speed = enemy_movement.movement_speed
	turn_speed = enemy_movement.turn_speed
	wander_speed = enemy_movement.wander_speed
	wander_radius = enemy_movement.wander_radius
	attack_range = weap_data.attack_range

func _physics_process(delta: float) -> void:
	if knocked_back:
		return
		
	if is_dead or not can_move:
		return
		
	if current_target != null:
		if not is_instance_valid(current_target):
			current_target = null
			
	if current_target != null:
		_move_to_target(delta)
	else:
		wander(delta)

func _move_to_target(delta: float) -> void:
	var distance := user.global_position.distance_to(current_target.global_position)

	# --- ATTACK ---
	if distance <= attack_range:
		user.velocity = Vector3.ZERO
		target_in_attack_dist.emit(true)
		_apply_gravity(delta)
		user.move_and_slide()
		return
	else:
		target_in_attack_dist.emit(false)

	# --- NAVIGATION AGENT MOVEMENT ---
	if target_close:
		nav_agent.target_position = current_target.global_position
		
		var next_point = nav_agent.get_next_path_position()
		if not is_finite(next_point.x) or not is_finite(next_point.y) or not is_finite(next_point.z):
			user.velocity.x = 0.0
			user.velocity.z = 0.0
			_apply_gravity(delta)
			user.move_and_slide()
			return
		
		var move_vec = next_point - user.global_position
		move_vec.y = 0.0
		var direction = safe_normalized(move_vec)
		
		user.velocity.x = direction.x * speed
		user.velocity.z = direction.z * speed
		face_direction(direction, delta)
	else:
		var move_vec = current_target.global_position - user.global_position
		move_vec.y = 0.0
		var direction = safe_normalized(move_vec)
		
		user.velocity.x = direction.x * speed
		user.velocity.z = direction.z * speed
		face_direction(direction, delta)
	# Gravity
	_apply_gravity(delta)
	
	user.move_and_slide()

func wander(delta: float) -> void:
	# 1. IDLE LOGIC
	if wander_wait > 0:
		wander_wait -= delta
		user.velocity.x = move_toward(user.velocity.x, 0, wander_speed * delta)
		user.velocity.z = move_toward(user.velocity.z, 0, wander_speed * delta)
		_apply_gravity(delta)
		user.move_and_slide()
		if _is_wandering:
			_is_wandering = false
			idling.emit()
		return

	# 2. PICK NEW POINT (no NavAgent)
	if not has_wander_point:
		var random_pos = Vector3(
			randf_range(-wander_radius, wander_radius),
			0,
			randf_range(-wander_radius, wander_radius)
		)
		wander_point = user.global_position + random_pos
		has_wander_point = true

		if !_is_wandering:
			_is_wandering = true
			wandering.emit()

	# 3. MOVE DIRECTLY TOWARD POINT
	var to_point = wander_point - user.global_position
	to_point.y = 0.0

	if user.global_position.distance_to(wander_point) <= wander_reach_dist:
		has_wander_point = false
		wander_wait = idling_wait_time
		_apply_gravity(delta)
		user.move_and_slide()
		return

	var dir = safe_normalized(to_point)
	user.velocity.x = dir.x * wander_speed
	user.velocity.z = dir.z * wander_speed

	face_direction(dir, delta)
	_apply_gravity(delta)
	user.move_and_slide()

func _apply_gravity(delta: float) -> void:
	if not user.is_on_floor():
		user.velocity.y -= gravity * delta
	else:
		user.velocity.y = 0

func face_direction(dir: Vector3, delta: float) -> void:
	if model_base == null or not is_instance_valid(model_base):
		return

	dir.y = 0.0
	if dir.length_squared() <= 0.000001:
		return

	dir = dir.normalized()

	var target_yaw := atan2(dir.x, dir.z)
	var current_yaw := model_base.rotation.y
	var new_yaw := lerp_angle(current_yaw, target_yaw, turn_speed * delta)

	if not is_finite(new_yaw):
		push_error("Invalid yaw. dir=%s target_yaw=%s current_yaw=%s" % [dir, target_yaw, current_yaw])
		return

	model_base.rotation.y = new_yaw

func safe_normalized(v: Vector3) -> Vector3:
	if not is_finite(v.x) or not is_finite(v.y) or not is_finite(v.z):
		return Vector3.ZERO
	if v.length_squared() <= 0.000001:
		return Vector3.ZERO
	return v.normalized()

func _on_targeting_component_new_target(target: CharacterBody3D) -> void:
	current_target = target
	has_wander_point = false
	wander_wait = 0.0

func _on_targeting_component_targets_close(status: bool) -> void:
	target_close = status

func _on_enemy_health_component_dead() -> void:
	is_dead = true

func _on_enemy_health_component_revived() -> void:
	is_dead = false

func _on_knock_back_component_recovered() -> void:
	knocked_back = false

func _on_knock_back_component_knockbacked() -> void:
	knocked_back = true
