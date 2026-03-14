@icon("uid://cjn3o8xhhxxna")
class_name MovementComponent extends Node

signal moving(status: bool)

@onready var world_gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 


@export var user: CharacterBody3D = null
@export var model: Node3D = null
@export var nav_agent: NavigationAgent3D = null
@export var lunge_comp: LungeComponent = null

@export var move_speed: float
@export var turn_speed: float
@export var pointer_effect: PackedScene

var input_vec: Vector3
var can_move: bool = true
var using_click_move: bool = false

func _ready() -> void:
	input_vec = Vector3.ZERO
	can_move = true

func _physics_process(delta: float) -> void:
	if lunge_comp != null and lunge_comp.is_lunging:
		return
	
	
	if not can_move:
		user.velocity.x = 0
		user.velocity.z = 0
		user.velocity = Vector3.ZERO
		user.move_and_slide()
		return
	
	
	if not using_click_move:
		user.velocity.x = -input_vec.x * move_speed
		user.velocity.z = -input_vec.z * move_speed
		
		if not user.is_on_floor():
			user.velocity.y -= world_gravity * delta
		else:
			user.velocity.y = 0
		
		face_direction(input_vec, delta)
		user.move_and_slide()
		is_moving()
	
	else:
		if nav_agent.is_navigation_finished():
			using_click_move = false
			user.velocity.x = 0
			user.velocity.z = 0
		else:
			var next_position: Vector3 = nav_agent.get_next_path_position()
			var move_dir: Vector3 = next_position - user.global_position
			move_dir.y = 0.0
			
			if move_dir.length() > 0.05:
				move_dir = move_dir.normalized()
				user.velocity.x = move_dir.x *move_speed
				user.velocity.z = move_dir.z *move_speed
				face_direction(-move_dir,delta)
			else:
				using_click_move = false
				user.velocity.x = 0
				user.velocity.z = 0
				
		if not user.is_on_floor():
			user.velocity.y -= world_gravity * delta
		else:
			user.velocity.y = 0
		
		user.move_and_slide()
		is_moving()

func face_direction(dir: Vector3, delta: float) -> void: 
	if dir == Vector3.ZERO:
		return
	
	dir.y = 0.0
	dir = dir.normalized()
	
	var target_yaw := atan2(-dir.x, -dir.z)
	var current_yaw := model.rotation.y
	
	var new_yaw:= lerp_angle(current_yaw, target_yaw, turn_speed * delta)
	model.rotation.y = new_yaw

func is_moving() -> bool:
	var h := Vector2(user.velocity.x, user.velocity.z).length()
	if h > 0.1:
		moving.emit(true)
		return true
	else:
		moving.emit(false)
		return false

func set_move_to_target(target: Vector3) -> void:
	if not can_move or nav_agent == null:
		return
	nav_agent.target_position = target
	using_click_move = true

func stop_click_move() -> void:
	using_click_move = false
	user.velocity.x = 0
	user.velocity.z = 0

func is_currently_moving() -> bool:
	return Vector2(user.velocity.x, user.velocity.z).length() > 0.1

func has_move_intent() -> bool:
	return input_vec != Vector3.ZERO or using_click_move

func _on_health_component_dead() -> void:
	can_move = false
	using_click_move = false

func _on_health_component_revived() -> void:
	can_move = true
	using_click_move = false

func _on_player_input_component_move_intent_changed(intent: Vector3) -> void:
	if not can_move:
		input_vec = Vector3.ZERO
		return
		
	input_vec = intent
	
	if intent != Vector3.ZERO:
		using_click_move = false

func _on_combat_component_attack_started(_attack_index: int) -> void:
	can_move = false
	using_click_move = false
	user.velocity.x = 0
	user.velocity.z = 0

func _on_combat_component_attack_window_ended() -> void:
	can_move = true

func _on_progression_component_leveling(status: bool) -> void:
	if status:
		can_move = false
		using_click_move = false
	else:
		can_move = true

func _on_player_input_component_move_to_target(data: Dictionary) -> void:
	if not can_move:
		return
	if not data.get("hit", false):
		return
	var target: Vector3 = data.get("position", Vector3.ZERO)
	set_move_to_target(target)
