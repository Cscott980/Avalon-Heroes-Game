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
@onready var world_visual_player_data: WorldVisualPlayerData = $WorldVisualPlayerData


#@export var player_data: PlayerData
@export var hero_class: HeroClassResource
@export var player_name: String
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
	state_machine.Initializer()
	player_animation_component.apply_animation_data(hero_class)
	stat_component.apply_stats(hero_class.hero_stats)
	health_component.apply_player_health_data(hero_class.max_health, hero_class.hero_stats)
	ability_component.apply_ability_data(hero_class.hero_abilities)
	player_ui.get_player_visual_data(hero_class.class_defaults, hero_class.starting_equipment)
	player_ui.apply_ability_bar_health_data(hero_class.max_health)
	equipment_visuals.get_defults(hero_class.class_defaults)
	targets_in_range_component._update_closest_target()
	world_visual_player_data.apply_player_visual_data(player_name, progression_component.player_level)
	world_visual_player_data.apply_player_health_visual_data(hero_class.max_health)
	resource_pool_component.apply_resource_data(hero_class.resource_pool)
	
func _physics_process(delta: float) -> void:
	if state_machine.current_state:
		state_machine.current_state.physics_process(delta)

func _on_player_input_component_attack() -> void:
	if health_component.is_dead:
		return
	if equipment_visuals.is_sheathed or player_ui.invetory_open:
		return
	var attack_index = combat_component.request_attack()
	
	if attack_index == -1:
		return
	
	match attack_index:
		0: state_machine.change_state("AttackState1")
		1: state_machine.change_state("AttackState2")
		2: state_machine.change_state("AttackState3")

func _on_movement_component_moving(status: bool) -> void:
	if health_component.is_dead:
		return
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

func _on_shield_component_block_broke(cooldown: float) -> void:
	if health_component.is_dead:
		return
	pass # Replace with function body.

func _on_health_component_hurt() -> void:
	if health_component.is_dead:
		return
	if state_machine:
		state_machine.change_state("HurtState")

func _on_health_component_dead() -> void:
	if state_machine:
		state_machine.change_state("DeadState")
