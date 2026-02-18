class_name Enemy extends CharacterBody3D

@onready var enemy_health_component: EnemyHealthComponent = $EnemyHealthComponent
@onready var enemy_visuals_component: EnemyVisualComponent = %EnemyVisualsComponent
@onready var enemy_melee_combat_component: EnemyMeleeCombatComponent = %EnemyMeleeCombatComponent
@onready var enemy_range_combat_component: Node = %EnemyRangeCombatComponent
@onready var chase_component: Node = %ChaseComponent
@onready var ai_movement_component: Node = %AIMovementComponent
@onready var status_effect_component: Node = %StatusEffectComponent
@onready var enemy_level_component: EnemyLevelComponent = %EnemyLevelComponent
@onready var stat_component: StatComponent = %StatComponent
@onready var targeting_component: TargetingComponent = %TargetingComponent
@onready var ai_controller_component: AICOntrollerComponent = %AIControllerComponent
@onready var state_machine: EnemyStateMachine = %EnemyStateMachine
@onready var enemy_world_data_display: EnemyWorldDataDisplay = %EnemyWorldDataDisplay

@export var enemy_data: EnemyResource

func _ready() -> void:
	enemy_init()

func enemy_init() -> void:
	if enemy_data == null or not is_instance_valid(enemy_data):
		return
	enemy_visuals_component.apply_visuals(enemy_data.enemy_mesh)
	enemy_world_data_display.apply_world_display_data(enemy_data.name, enemy_level_component.level, enemy_data.max_health)
	enemy_health_component.apply_health_data(enemy_data.max_health, enemy_data.stats)
	
func _on_hurt_box_area_entered(_area: Area3D) -> void:
	state_machine.change_state("HurtState")
