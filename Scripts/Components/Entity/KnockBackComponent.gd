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

func _physics_process(delta: float) -> void:
	if user == null:
		return

	if not _active:
		return

	_t += delta

	# strength fades from 1 -> 0 over knockback_duration
	var k := 1.0
	if knockback_duration > 0.0:
		k = 1.0 - clamp(_t / knockback_duration, 0.0, 1.0)

	# apply push on XZ
	user.velocity.x = _dir.x * knockback_force * k
	user.velocity.z = _dir.z * knockback_force * k

	# gravity
	if not user.is_on_floor():
		user.velocity.y -= gravity * delta
	else:
		# don't kill hop if you set it in knockback()
		if user.velocity.y < 0.0:
			user.velocity.y = 0.0

	user.move_and_slide()

	# stop pushing after duration (AI will still be paused until recovered emits)
	if _t >= knockback_duration:
		_active = false
		# optionally zero XZ so you don't keep drifting
		user.velocity.x = 0.0
		user.velocity.z = 0.0
	
	if _t >= knockback_duration:
		_active = false
		recovered.emit() # AI can resume right away

func knockback() -> void:
	can_be_knockedback = false

	_dir = user.global_position - hit_pos
	_dir.y = 0.0
	if _dir.length_squared() < 0.0001:
		_dir = -user.global_transform.basis.z
	_dir = _dir.normalized()

	if user.is_on_floor() and up_force > 0.0:
		user.velocity.y = up_force

	_active = true
	_t = 0.0
	knockbacked.emit()
	knock_back_timer.start()

func _on_knock_back_timer_timeout() -> void:
	can_be_knockedback = true
	recovered.emit()
	knock_back_timer.stop()

func _on_enemy_hurt_box_component_hit(area: Area3D) -> void:
	hit_pos = area.global_position
	knockback()
