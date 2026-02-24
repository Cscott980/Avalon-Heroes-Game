class_name KnockBackComponent extends Node

signal knockbacked
signal recovered

@onready var knock_back_timer: Timer = %KnockBackTimer
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var user: CharacterBody3D

@export var knockback_force: float = 8.0
@export var knockback_duration: float = 0.15  # how long the push lasts (feel)
@export var knockback_cooldown: float = 0.25  # how soon can be knocked again
@export var up_force: float = 1.0             # optional small hop

var can_be_knockedback: bool = true
var hit_pos: Vector3 = Vector3.ZERO

var _active: bool = false
var _dir: Vector3 = Vector3.ZERO
var _t: float = 0.0

func _ready() -> void:
	can_be_knockedback = true
	knock_back_timer.wait_time = knockback_cooldown

func knockback() -> void:
	if user == null:
		push_warning("KnockBackComponent: user is null.")
		return
	if not can_be_knockedback:
		return

	can_be_knockedback = false

	_dir = user.global_position - hit_pos
	_dir.y = 0.0
	if _dir.length_squared() < 0.0001:
		_dir = -user.global_transform.basis.z
	_dir = _dir.normalized()

	# Optional pop upward on start
	if user.is_on_floor() and up_force > 0.0:
		user.velocity.y = up_force

	_active = true
	_t = 0.0
	print("knockback")
	knockbacked.emit()
	knock_back_timer.start()

func _on_knock_back_timer_timeout() -> void:
	can_be_knockedback = true
	recovered.emit()
	knock_back_timer.stop()
	
func _on_enemy_hurt_box_component_hit(area: Area3D) -> void:
	print("knockback recived signal")
	if not can_be_knockedback:
		print("knock back is false")
		return
	
	hit_pos = area.global_position
	knockback()
