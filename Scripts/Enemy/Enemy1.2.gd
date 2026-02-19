class_name Enemy extends CharacterBody3D

@onready var enemy_health_component: EnemyHealthComponent = $EnemyHealthComponent
@onready var enemy_visuals_component: EnemyVisualComponent = %EnemyVisualsComponent
@onready var enemy_melee_combat_component: EnemyMeleeCombatComponent = %EnemyMeleeCombatComponent
@onready var enemy_range_combat_component: Node = %EnemyRangeCombatComponent # missing comp
@onready var chase_component: ChaseComponent = %ChaseComponent
@onready var ai_movement_component: AICOntrollerComponent = %AIMovementComponent
@onready var status_effect_component: StatusEffectComponent = %StatusEffectComponent
@onready var enemy_level_component: EnemyLevelComponent = %EnemyLevelComponent
@onready var stat_component: StatComponent = %StatComponent
@onready var targeting_component: TargetingComponent = %TargetingComponent
@onready var ai_controller_component: AICOntrollerComponent = %AIControllerComponent
@onready var state_machine: EnemyStateMachine = %EnemyStateMachine
@onready var enemy_world_data_display: EnemyWorldDataDisplay = %EnemyWorldDataDisplay
@onready var enemy_animation_component: EnemyAnimationComponent = %EnemyAnimationComponent
@onready var enemy_main_hand_component: EnemyMainHandComponent = %EnemyMainHandComponent

@export var enemy_data: EnemyResource

func _ready() -> void:
	enemy_init()

func enemy_init() -> void:
	if enemy_data == null or not is_instance_valid(enemy_data):
		return
	enemy_visuals_component.apply_visuals(enemy_data.enemy_mesh)
	enemy_main_hand_component.apply_mainhand_weapon_visual_data(enemy_data.weapon_data)
	enemy_world_data_display.apply_world_display_data(enemy_data.name, enemy_level_component.level, enemy_data.max_health)
	enemy_health_component.apply_health_data(enemy_data.max_health, enemy_data.stats)
	enemy_animation_component.apply_animation_playback(enemy_data)
	
	
func _on_hurt_box_area_entered(_area: Area3D) -> void:
	state_machine.change_state("HurtState")

func _on_world_level_manager_level_up(new_level) -> void:
	enemy_level_component.world_diffuculty_level = new_level
	
