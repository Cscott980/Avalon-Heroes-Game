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


#@export var player_data: PlayerData
@export var hero_class: HeroClassResource

@export var player_id: int = 1
@export var multiplayer_id: int = 0

func _ready() -> void:
	if not is_instance_valid(hero_class):
		return

func hero_init() -> void: 
	if not is_instance_valid(hero_class):
		return
	stat_component.apply_stats(hero_class.hero_stats)
	equipment_visuals.apply_defults(hero_class.class_defaults)
	equipment_visuals.apply_starter_equipment(hero_class.starting_equipment)
	

func _physics_process(delta: float) -> void:
	if state_machine.current_state:
		state_machine.current_state.physics_process(delta)

func _on_hurt_box_take_damage(_amount: int) -> void:
	state_machine.change_state("HurtState")

func _on_player_input_component_attack() -> void:
	state_machine.change_state("AttackState1")

func _on_movement_component_moving(status: bool) -> void:
	if status:
		state_machine.change_state("MoveState")
	else:
		state_machine.change_state("IdleState")
