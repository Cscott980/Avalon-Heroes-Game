class_name AICOntrollerComponent extends Node

signal moving
signal wandering
signal target_in_attack_dist(status: bool)
signal no_dirrection

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
	can_move = true

func _physics_process(delta: float) -> void:
	if current_target != null:
		_move_to_target(current_target, delta)
	
	if current_target == null:
		user.velocity = Vector3.ZERO
		wandering.emit()
		#_wander()

func _move_to_target(dir: CharacterBody3D, delta: float) -> void:
	if not can_move:
		return
		
	if current_target == null:
		user.velocity = Vector3.ZERO
		wander()
	
	if nav_agent.distance_to_target() <= attack_range:	
		user.velocity = Vector3.ZERO
		target_in_attack_dist.emit(true)
		user.move_and_slide()
		return
		
	if target_close:
		await get_tree().create_timer(5.0).timeout
		
		nav_agent.target_position = current_target.global_position
		
		if not user.is_on_floor():
			user.velocity.y -= gravity * delta
		
		var next_point = nav_agent.get_next_path_position()
		var direction = (next_point - user.global_position).normalized()
		
		user.velocity.x = direction.x * speed 
		user.velocity.z = direction.z * speed
		
		rotate_model()
		
		target_in_attack_dist.emit(false)
		user.move_and_slide()
	else:
		
		var direction = (current_target.global_position - user.global_position).normalized()
		
		if not user.is_on_floor():
			user.velocity.y -= gravity * delta
			
		user.velocity.x = direction.x * speed 
		user.velocity.z = direction.z * speed
		
		rotate_model()
		
		user.move_and_slide()
		
func apply_movement_data(data: EnemyMovementResource, weap_data: EnemyWeaponResource) -> void:
	speed = data.movement_speed
	turn_speed = data.trun_speed
	wander_speed = data.wander_speed
	wander_radius = data.wander_radius

func wander() -> void:
	var wandering_direction = Vector3(
		randf_range(-wander_radius, wander_radius),
		0,
		randf_range(-wander_radius, wander_radius)
	)
	var direction = (wandering_direction - user.global_position).normalized()
	
	user.velocity.x = direction.x * wander_speed 
	user.velocity.z = direction.z * wander_speed
	
	model_base.look_at(wandering_direction, Vector3.UP)
	model_base.rotate_y(deg_to_rad(model_base.rotation.y * turn_speed))
	
	wandering.emit()
	user.move_and_slide()

func rotate_model() -> void:
	model_base.look_at(current_target.global_position, Vector3.UP)
	model_base.rotate_y(deg_to_rad(model_base.rotation.y * turn_speed))

func _on_targeting_component_new_target(target: CharacterBody3D) -> void:
	current_target = target

func _on_targeting_component_targets_close() -> void:
	target_close = true
