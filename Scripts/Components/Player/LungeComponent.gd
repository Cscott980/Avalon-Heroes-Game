@icon("uid://bc4rxmxa331au")
class_name LungeComponent extends Node

@onready var lunge_timer: Timer = %LungeTimer

@export var player: Player
@export var targeting_comp: TargetsInRangeComponent
@export var weap_equip_comp: WeaponEquipComponent

@export var stop_distance: float = 0.9

var current_target: CharacterBody3D

var is_lunging: bool = false
var can_lunge: bool = true
var lunge_direction: Vector3 = Vector3.ZERO

var attack_type: int
var lunge_speed: float = 1.0
var root_motion_speed: float = 1.0

func _physics_process(_delta: float) -> void:
	if not is_lunging:
		return
	
	if current_target == null or not is_instance_valid(current_target):
		_end_lunge()
		return

	var dist := player.global_position.distance_to(current_target.global_position)
	if dist <= stop_distance:
		_end_lunge()
		return

	player.velocity.x = lunge_direction.x * lunge_speed
	player.velocity.z = lunge_direction.z * lunge_speed
	player.move_and_slide()
	
func apply_lunge_data(main_hand_weapon_data: WeaponResource) -> void:
	attack_type = main_hand_weapon_data.attack_type

func lunge(combo: AttackDataResource) -> void:
	if current_target == null and targeting_comp != null:
		current_target = targeting_comp.current_target
	
	if current_target == null or not is_instance_valid(current_target):
		print("lunge blocked: no target")
		return
	
	if not combo.lunge_to_target:
		print("lunge blocked: combo says no lunge")
		return
	
	if not can_lunge:
		print("lunge blocked: can_lunge false")
		return
	
	if attack_type == WeaponResource.ATTACK_TYPE.RANGED:
		print("lunge blocked: ranged weapon")
		return
	
	lunge_speed = combo.lunge_speed
	root_motion_speed = combo.root_motion_speed
	
	var target_distance := player.global_position.distance_to(current_target.global_position)
	print("lunge target distance: ", target_distance)
	
	if target_distance > combo.lunge_distance_max or target_distance <= 0.5:
		print("lunge blocked: bad distance")
		return
	
	lunge_direction = current_target.global_position - player.global_position
	lunge_direction.y = 0.0
	
	if lunge_direction.length_squared() < 0.0001:
		print("lunge blocked: zero direction")
		return
	
	lunge_direction = lunge_direction.normalized()
	
	is_lunging = true
	can_lunge = false
	lunge_timer.wait_time = max(combo.lunge_duration, 0.01)
	lunge_timer.start()
	
	var target_rotation := atan2(lunge_direction.x, lunge_direction.z)
	player.movement_component.model.rotation.y = target_rotation
	
	print("LUNGE STARTED")

func _end_lunge() -> void:
	is_lunging = false
	can_lunge = true
	lunge_direction = Vector3.ZERO
	lunge_speed = 0.0
	player.velocity.x = 0.0
	player.velocity.z = 0.0

func _on_lunge_timer_timeout() -> void:
	_end_lunge()

func _on_targets_in_range_component_target_change(new_target: CharacterBody3D) -> void:
	current_target = new_target

func _on_player_input_component_attack_target_requested(target: Enemy) -> void:
	current_target = target
