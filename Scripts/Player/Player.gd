class_name Player extends CharacterBody3D

@onready var state_machine: PlayerStateMachine = %StateMachine
@onready var equipment_visuals: EquipmentVisualComponent = %Rig_Medium
@onready var health_component: HealthComponent = %HealthComponent
@onready var stat_component: StatComponent = %StatComponent
@onready var ability_component: AbilityComponent = %AbilityComponent

#@export var player_data: PlayerData
@export var hero_class: HeroClassResource

@export var player_id: int = 1
@export var multiplayer_id: int = 0

func _ready() -> void:
	if not is_instance_valid(hero_class):
		return
	hero_class_init()

func _physics_process(delta: float) -> void:
	if state_machine.current_state:
		state_machine.current_state.physics_process(delta)

func hero_class_init() -> void:
	if hero_class == null:
		push_warning("Player: Missing hero_class.")
		return
	stat_component.stats = hero_class.hero_stats
	health_component.max_health = hero_class.max_health

func _on_hurt_box_take_damage(_amount: int) -> void:
	state_machine.change_state("HurtState")



func _on_player_input_component_attack() -> void:
	state_machine.change_state("AttackState1")


func _on_movement_component_moving(status: bool) -> void:
	if status:
		state_machine.change_state("MoveState")
	else:
		state_machine.change_state("IdleState")
