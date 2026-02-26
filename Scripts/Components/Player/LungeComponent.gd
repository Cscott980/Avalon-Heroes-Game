@icon("uid://bc4rxmxa331au")
class_name LungeComponent extends Node
@onready var lunge_timer: Timer = %LungeTimer

@export var player: Player
@export var targeting_comp: TargetsInRangeComponent
@export var weap_equip_comp: WeaponEquipComponent

@export var stop_distance: float = 0.9  

var current_target: CharacterBody3D

var is_lunging = false
var can_lunge = true
var lunge_direction: Vector3

var attack_type: int
var lunge_speed: float
var root_motion_speed

func apply_lunge_data(main_hand_weapon_data: WeaponResource) -> void:
	attack_type = main_hand_weapon_data.attack_type

func _physics_process(_delta: float) -> void:
	if not is_lunging:
		return

	
	if current_target == null or not is_instance_valid(current_target):
		_end_lunge()
		return

	# Stop early if close enough
	var dist := targeting_comp.get_distance_to_current_target()
	if dist <= stop_distance:
		_end_lunge()
		return

	# Apply motion (horizontal only)
	player.velocity.x = lunge_direction.x * lunge_speed
	player.velocity.z = lunge_direction.z * lunge_speed
	
	player.move_and_slide()

func lunge(combo: AttackDataResource) -> void:	
	if current_target == null or not is_instance_valid(current_target):
		return
	if not combo.lunge_to_target:
		return
	if not can_lunge:
		return
	if attack_type == WeaponResource.ATTACK_TYPE.RANGED:
		return
		
	lunge_speed = combo.lunge_speed
	root_motion_speed = combo.root_motion_speed
		
	var target_distance: float = targeting_comp.get_distance_to_current_target()
	if target_distance > combo.lunge_distance_max or target_distance <= 0.5:
		return
		
	lunge_direction = targeting_comp.get_direction_to_current_target()
	lunge_direction.y = 0.0
	if lunge_direction.length_squared() < 0.0001:
		return
	lunge_direction = lunge_direction.normalized()
	
	is_lunging = true
	can_lunge = false
	lunge_timer.wait_time = max(combo.lunge_duration, 0.01)
	lunge_timer.start()
	
	var target_rotation: float = atan2(lunge_direction.x, lunge_direction.z)
	player.movement_component.model.rotation.y = target_rotation

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
