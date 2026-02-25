class_name LungeComponent extends Node
@onready var lunge_timer: Timer = %LungeTimer

@export var player: Player
@export var targeting_comp: TargetsInRangeComponent

@export var leap_distance: float 
@export var attack_range: float 

var current_target: CharacterBody3D

var is_lunging = false
var lunge_direction: Vector3

func lunge() -> void:
	if current_target == null:
		return
	
	var target_distance = targeting_comp.get_distance_to_current_target()
	
	#if target_distance <= attack_data.lunge_distance_max and target_distance > 0.5:
		#is_lunging = true
		#lunge_timer.wait_time = attack_data.lunge_duration
		#lunge_direction = targeting_comp.get_direction_to_current_target()
		
		#if lunge_direction != Vector3.ZERO:
			#var target_rotation = atan2(lunge_direction.x, lunge_direction.z)
			#player.movement_component.model.rotation.y = target_rotation
