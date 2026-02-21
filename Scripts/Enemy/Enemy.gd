class_name Enemy extends CharacterBody3D

@onready var state_machine: EnemyStateMachine = %EnemyStateMachine

@onready var enemy_health_component: EnemyHealthComponent = $EnemyHealthComponent
@onready var enemy_visuals_component: EnemyVisualComponent = %EnemyVisualsComponent
@onready var enemy_melee_combat_component: EnemyMeleeCombatComponent = %EnemyMeleeCombatComponent
#@onready var enemy_range_combat_component: Node = %EnemyRangeCombatComponent 
@onready var ai_movement_component: AIControllerComponent = %AIControllerComponent
@onready var status_effect_component: StatusEffectComponent = %StatusEffectComponent
@onready var enemy_level_component: EnemyLevelComponent = %EnemyLevelComponent
@onready var stat_component: StatComponent = %StatComponent
@onready var targeting_component: TargetingComponent = %TargetingComponent
@onready var enemy_world_data_display: EnemyWorldDataDisplay = %EnemyWorldDataDisplay
@onready var enemy_animation_component: EnemyAnimationComponent = %EnemyAnimationComponent
@onready var enemy_main_hand_component: EnemyMainHandComponent = %EnemyMainHandComponent
@onready var weapon_shield_relic: EnemyOffHandComponent = %WeaponShieldRelic

@export var enemy_data: EnemyResource

func _ready() -> void:
	enemy_init()

func enemy_init() -> void:
	if state_machine == null or not is_instance_valid(state_machine):
		return
	state_machine.Initializer()
	if enemy_data == null or not is_instance_valid(enemy_data):
		return
	ai_movement_component.apply_movement_data(enemy_data.movement_data, enemy_data.weapon_data)
	enemy_visuals_component.apply_visuals(enemy_data.enemy_mesh)
	enemy_main_hand_component.apply_mainhand_weapon_visual_data(enemy_data.weapon_data)
	weapon_shield_relic.apply_offhand_weapon_visual_data(enemy_data.weapon_data)
	enemy_melee_combat_component.apply_melee_weapon_data(enemy_data.weapon_data)
	enemy_world_data_display.apply_world_display_data(enemy_data.name, enemy_level_component.level, enemy_data.max_health)
	enemy_health_component.apply_health_data(enemy_data.max_health, enemy_data.stats)
	enemy_animation_component.apply_animation_playback(enemy_data)
	
	
	
func _on_hurt_box_area_entered(_area: Area3D) -> void:
	if enemy_health_component.is_dead:
		return
	if state_machine:
		state_machine.change_state("HurtState")

func _on_enemy_spawn_component_spawn() -> void:
	if state_machine:
		state_machine.change_state("SpawnState")

func _on_ai_controller_component_target_in_attack_dist(status: bool) -> void:
	if enemy_health_component.is_dead: 
		return
	if status: 
		state_machine.change_state("AttackState")
	else:
		state_machine.change_state("ChaseState")

func _on_enemy_health_component_dead() -> void:
	self.remove_from_group("enemies")
	self.add_to_group("dead_enemies")
	
	ai_movement_component.can_move = false
	state_machine.change_state("DeadState")
