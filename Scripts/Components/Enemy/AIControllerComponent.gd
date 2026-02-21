class_name AIControllerComponent extends Node

signal moving(status: bool)
signal wandering
signal target_in_attack_dist(status: bool)

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var user: CharacterBody3D
@export var model_base: Node3D
@export var speed: float
@export var turn_speed: float
@export var wander_radius: float
@export var wander_speed: float


var current_target: CharacterBody3D
var can_move: bool = false
var attack_range: float
var target_close: bool 

func _ready() -> void:
	await  get_tree().process_frame
	can_move = true

func _physics_process(delta: float) -> void:
	if not can_move:
		user.velocity = Vector3.ZERO
		return
		
	if current_target != null:
		_move_to_target(delta)
	
	if current_target == null:
		wander(delta)

func _move_to_target(delta: float) -> void:
	if not can_move:
		return
		
	if target_close:
		nav_agent.target_position = current_target.global_position
		
		if not user.is_on_floor():
			user.velocity.y -= gravity * delta
		
		var next_point = nav_agent.get_next_path_position()
		var direction = (next_point - user.global_position).normalized()
		
		user.velocity.x = direction.x * speed
		user.velocity.z = direction.z * speed
		
		if nav_agent.distance_to_target() <= attack_range:
			user.velocity = Vector3.ZERO
			target_in_attack_dist.emit(true)
			user.move_and_slide()
			return
		
		rotate_model()
		moving.emit(true)
		target_in_attack_dist.emit(false)
		user.move_and_slide()
	else:
		
		var direction = (current_target.global_position - user.global_position).normalized()
		
		if not user.is_on_floor():
			user.velocity.y -= gravity * delta
			
		user.velocity.x = direction.x * speed 
		user.velocity.z = direction.z * speed
		
		rotate_model()
		moving.emit(true)
		user.move_and_slide()
		
func apply_movement_data(enemy_movement: EnemyMovementResource, weap_data: EnemyWeaponResource) -> void:
	speed = enemy_movement.movement_speed
	turn_speed = enemy_movement.turn_speed
	wander_speed = enemy_movement.wander_speed
	wander_radius = enemy_movement.wander_radius
	attack_range = weap_data.attack_range

func wander(delta: float) -> void:
	var wandering_direction = user.global_position + Vector3(
		randf_range(-wander_radius, wander_radius),
		0,
		randf_range(-wander_radius, wander_radius)
	)
	var direction = (wandering_direction - user.global_position).normalized()
	
	user.velocity.x = direction.x * wander_speed 
	user.velocity.z = direction.z * wander_speed
	
	model_base.look_at(wandering_direction, Vector3.UP)
	model_base.rotate_y(deg_to_rad(model_base.rotation.y * turn_speed))
	
	if not user.is_on_floor():
		user.velocity.y -= gravity * delta
	
	wandering.emit()
	user.move_and_slide()

func rotate_model() -> void:
	if user.global_position.is_equal_approx(current_target.global_position):
		return
	model_base.look_at(current_target.global_position, Vector3.UP)
	model_base.rotate_y(PI)

func _on_targeting_component_new_target(target: CharacterBody3D) -> void:
	current_target = target

func _on_targeting_component_targets_close(status: bool) -> void:
	if status:
		target_close = true
	else:
		target_close = false

func _on_status_effect_component_stuned() -> void:
	pass # Replace with function body.

func _on_status_effect_component_status_ended() -> void:
	pass # Replace with function body.

func _on_status_effect_component_slowed(_new_speed: float) -> void:
	pass # Replace with function body.

func _on_status_effect_component_rooted() -> void:
	pass # Replace with function body.

func _on_enemy_spawn_component_spawn() -> void:
	can_move = false

func _on_enemy_spawn_component_spawned() -> void:
	can_move = true

func _on_hurt_box_component_hit() -> void:
	can_move = false

func _on_hurt_box_component_not_hits() -> void:
	can_move = true

func _on_enemy_health_component_dead() -> void:
	can_move = false

func _on_enemy_health_component_revived() -> void:
	can_move = true
