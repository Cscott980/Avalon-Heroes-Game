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

var can_move: bool = false
var has_wander_point := false
var _is_wandering := false
var target_close: bool = false

var wander_wait:float = 0.0
var attack_range: float = 0.0

var wander_point: Vector3

func _physics_process(delta: float) -> void:
	if not can_move:
		user.velocity = Vector3.ZERO
		return
		
	if current_target != null:
		_move_to_target(delta)
	
	if current_target == null:
		wander(delta)

func _move_to_target(delta: float) -> void:
	var distance := user.global_position.distance_to(current_target.global_position)

	# --- ATTACK ---
	if distance <= attack_range:
		user.velocity = Vector3.ZERO
		target_in_attack_dist.emit(true)
		user.move_and_slide()
		return
	else:
		target_in_attack_dist.emit(false)

	# --- NAVIGATION AGENT MOVEMENT ---
	if target_close:
		nav_agent.target_position = current_target.global_position
		
		var next_point = nav_agent.get_next_path_position()
		var direction = (next_point - user.global_position).normalized()
		
		user.velocity.x = direction.x * speed
		user.velocity.z = direction.z * speed
		face_direction(direction, delta)
	# --- DIRECT MOVEMENT ---
	else:
		var direction = (current_target.global_position - user.global_position).normalized()
		
		user.velocity.x = direction.x * speed
		user.velocity.z = direction.z * speed
		face_direction(direction, delta)
	# Gravity
	if not user.is_on_floor():
		user.velocity.y -= gravity * delta
	
	rotate_model()
	user.move_and_slide()
		
func apply_movement_data(enemy_movement: EnemyMovementResource, weap_data: EnemyWeaponResource) -> void:
	speed = enemy_movement.movement_speed
	turn_speed = enemy_movement.turn_speed
	wander_speed = enemy_movement.wander_speed
	wander_radius = enemy_movement.wander_radius
	attack_range = weap_data.attack_range

func wander(delta: float) -> void:
	# If we’re waiting, stand still (IDLE)
	if wander_wait > 5.0:
		if _is_wandering:
			_is_wandering = false
		wander_wait -= delta
		user.velocity.x = 0
		user.velocity.z = 0

		if not user.is_on_floor():
			user.velocity.y -= gravity * delta
		else:
			user.velocity.y = 0
		user.move_and_slide()
		return

	# Pick a destination only when we need one
	if not has_wander_point:
		wander_point = user.global_position + Vector3(
			randf_range(-wander_radius, wander_radius),
			0,
			randf_range(-wander_radius, wander_radius)
		)
		has_wander_point = true

	# Move toward it
	var to_point := wander_point - user.global_position
	to_point.y = 0
	var dist := to_point.length()

	# Reached it -> pause, then pick a new one
	if dist <= wander_reach_dist:
		has_wander_point = false
		wander_wait = idling_wait_time
		user.velocity.x = 0
		user.velocity.z = 0

		if not user.is_on_floor():
			user.velocity.y -= gravity * delta
		else:
			user.velocity.y = 0
		idling.emit()
		user.move_and_slide()
		return

	var dir := to_point.normalized()
	
	
	user.velocity.x = dir.x * wander_speed
	user.velocity.z = dir.z * wander_speed

	
	face_direction(dir, delta)

	if not user.is_on_floor():
		user.velocity.y -= gravity * delta
	else:
		user.velocity.y = 0
	
	if not _is_wandering:
		_is_wandering = true
		
	
	wandering.emit()
	user.move_and_slide()

func face_direction(dir: Vector3, delta: float) -> void: 
	if dir == Vector3.ZERO:
		return
	
	dir.y = 0.0
	dir = dir.normalized()
	
	var target_yaw := atan2(-dir.x, -dir.z)
	var current_yaw := model_base.rotation.y
	
	var new_yaw:= lerp_angle(current_yaw, target_yaw, turn_speed * delta)
	model_base.rotation.y = new_yaw

func rotate_model() -> void:
	if user.global_position.is_equal_approx(current_target.global_position):
		return
	model_base.look_at(current_target.global_position, Vector3.UP)
	model_base.rotate_y(PI)

func _on_targeting_component_new_target(target: CharacterBody3D) -> void:
	current_target = target
	has_wander_point = false
	wander_wait = 0.0

func _on_targeting_component_targets_close(status: bool) -> void:
	if status:
		target_close = true
	else:
		target_close = false

func _on_hurt_box_component_hit() -> void:
	can_move = false

func _on_hurt_box_component_not_hits() -> void:
	can_move = true

func _on_enemy_health_component_dead() -> void:
	can_move = false

func _on_enemy_health_component_revived() -> void:
	can_move = true
