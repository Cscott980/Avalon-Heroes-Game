class_name Player extends CharacterBody3D

@onready var state_machine: PlayerStateMachine = %StateMachine
@onready var equipment_visuals: EquipmentVisualComponent = %EquipmentVisualComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var stat_component: StatComponent = %StatComponent
@onready var ability_component: AbilityComponent = %AbilityComponent
@onready var targets_in_range_component: TargetsInRangeComponent = %TargetsInRangeComponent
@onready var weapon_equip_component: WeaponEquipComponent = %WeaponEquipComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var combat_component: CombatComponent = %CombatComponent
@onready var resource_pool_component: ResourcePoolComponent = %ResourcePoolComponent
@onready var progression_component: ProgressionComponent = %ProgressionComponent
@onready var player_input_component: PlayerInputComponent = %PlayerInputComponent
@onready var player_animation_component: PlayerAnimationComponent = %PlayerAnimationComponent
@onready var player_ui: MainUI = %PlayerUI


#@export var player_data: PlayerData
@export var hero_class: HeroClassResource
@export var player_id: int = 1
@export var multiplayer_id: int = 0

var combo_open: bool = false

func _ready() -> void:
	if not is_instance_valid(hero_class):
		return
	hero_init()

func hero_init() -> void: 
	if not is_instance_valid(hero_class):
		return
	stat_component.apply_stats(hero_class.hero_stats)
	health_component.apply_player_health_data(hero_class.max_health)
	ability_component.apply_ability_data(hero_class.hero_abilities)
	player_ui.get_player_visual_data(hero_class.class_defaults, hero_class.starting_equipment)
	equipment_visuals.get_defults(hero_class.class_defaults)
	
func _physics_process(delta: float) -> void:
	if state_machine.current_state:
		state_machine.current_state.physics_process(delta)

func _on_hurt_box_take_damage(_amount: int) -> void:
	state_machine.change_state("HurtState")

func _on_player_input_component_attack() -> void:
	var attack_index = combat_component.request_attack()
	
	if attack_index == -1:
		return
	
	match attack_index:
		0: state_machine.change_state("AttackState1")
		1: state_machine.change_state("AttackState2")
		2: state_machine.change_state("AttackState3")

## ROBUST FIX: Check if currently attacking using CombatComponent state
func _on_movement_component_moving(status: bool) -> void:
	# Block movement state changes while attacking
	# Use CombatComponent's is_attacking flag for reliable check
	if combat_component.is_attacking:
		return  # Ignore movement input during attacks
	
	# Normal movement behavior
	if status:
		state_machine.change_state("MoveState")
	else:
		state_machine.change_state("IdleState")

func _on_combat_component_combo_window_open() -> void:
	if combat_component.attack_queued:
		_on_player_input_component_attack()

## CRITICAL: Return to Idle when attack window ends
func _on_combat_component_attack_window_ended() -> void:
	# Attack is complete, return to appropriate state
	# Check movement AFTER attack finishes
	if movement_component.is_moving:
		state_machine.change_state("MoveState")
	else:
		state_machine.change_state("IdleState")

## Optional: Handle combo completion
func _on_combat_component_combo_completed() -> void:
	print("Full combo completed!")
	if movement_component.is_moving:
		state_machine.change_state("MoveState")
	else:
		state_machine.change_state("IdleState")

## Optional: Handle combo break/reset
