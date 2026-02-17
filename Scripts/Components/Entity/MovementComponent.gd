@icon("uid://cjn3o8xhhxxna")
class_name MovementComponent extends Node

signal moving(status: bool)

@onready var world_gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 

@export var user: CharacterBody3D
@export var model: Node3D
@export var move_speed: float
@export var turn_speed: float

var input_vec: Vector3
var can_move: bool

func _ready() -> void:
	input_vec = Vector3.ZERO
	can_move = true

func _physics_process(delta: float) -> void:
	if not can_move:
		return 

	user.velocity.x = -input_vec.x * move_speed
	user.velocity.z = -input_vec.z * move_speed
	
	if not user.is_on_floor():
		user.velocity.y -= world_gravity * delta
	else:
		user.velocity.y = 0
	
	face_direction(input_vec, delta)
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

func is_moving() -> void:
	var h := Vector2(user.velocity.x, user.velocity.z).length()
	if h > 0.1:
		moving.emit(true)
	else:
		moving.emit(false)

func _on_health_component_dead(_owner: Node) -> void:
	can_move = false

func _on_health_component_revived(_owner: Node) -> void:
	can_move = true

func _on_player_input_component_move_intent_changed(intent: Vector3) -> void:
	input_vec = intent

func _on_combat_component_attack_started(_attack_index: int) -> void:
	can_move = false
	
func _on_combat_component_attack_window_ended() -> void:
	can_move = true
