class_name KnockBackComponent extends Node

signal knockbacked
signal recovered

@onready var knock_back_timer: Timer = %KnockBackTimer
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var user: CharacterBody3D

@export var knockback_force: float = 8.0
@export var knockback_duration: float = 0.15  # how long the push lasts (feel)
@export var knockback_cooldown: float = 0.25  # how soon can be knocked again
@export var up_force: float = 0.0             # optional small hop

var can_be_knockedback: bool = true
var hit_pos: Vector3 = Vector3.ZERO

var _active: bool = false
var _dir: Vector3 = Vector3.ZERO
var _t: float = 0.0

func _ready() -> void:
	knock_back_timer.wait_time = knockback_cooldown

func _physics_process(delta: float) -> void:
	if not _active:
		return
	if user == null:
		_active = false
		return

	_t += delta
	var p: float = clamp(_t / max(0.01, knockback_duration), 0.0, 1.0)

	# Ease out: strong at start, fades smoothly
	var strength: float = 1.0 - (p * p)

	user.velocity.x = _dir.x * knockback_force * strength
	user.velocity.z = _dir.z * knockback_force * strength

	# gravity
	if not user.is_on_floor():
		user.velocity.y -= gravity * delta
	else:
		if user.velocity.y < 0.0:
			user.velocity.y = 0.0

	user.move_and_slide()

	if p >= 1.0:
		_active = false
		_t = 0.0
		# let AI resume
		recovered.emit()

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

	knockbacked.emit()
	knock_back_timer.start()

func _on_knock_back_timer_timeout() -> void:
	# cooldown over, can be knocked again
	can_be_knockedback = true
	knock_back_timer.stop()


func _on_hurt_box_component_hit(area: Area3D)-> void:
	if not can_be_knockedback:
		return

	hit_pos = area.global_position
	knockback()
