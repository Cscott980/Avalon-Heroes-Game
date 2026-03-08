class_name Enemy extends CharacterBody3D

signal finished(enemy: Enemy)
signal spawned(enemy: Enemy)


@onready var state_machine: EnemyStateMachine = %EnemyStateMachine
@onready var enemy_world_data_display: EnemyWorldDataDisplay = %EnemyWorldDataDisplay
@onready var despawn_timer: Timer = %DeSpawnTimer
@onready var enemy_audio_component: AudioStreamPlayer3D = %EnemyAudioComponent
@onready var enemy_audio_component_2: EnemyAudioComponent = %EnemyAudioComponent2

@onready var enemy_health_component: EnemyHealthComponent = $EnemyHealthComponent
@onready var enemy_visual_component: EnemyVisualComponent = %EnemyVisualComponent
@onready var enemy_melee_combat_component: EnemyMeleeCombatComponent = %EnemyMeleeCombatComponent
@onready var enemy_range_combat_component: Node = %EnemyRangeCombatComponent 
@onready var ai_movement_component: AIControllerComponent = %AIControllerComponent
@onready var status_effect_component: StatusEffectComponent = %StatusEffectComponent
@onready var enemy_level_component: EnemyLevelComponent = %EnemyLevelComponent
@onready var targeting_component: TargetingComponent = %TargetingComponent
@onready var enemy_animation_component: EnemyAnimationComponent = %EnemyAnimationComponent
@onready var enemy_main_hand_component: EnemyMainHandComponent = %EnemyMainHandComponent
@onready var weapon_shield_relic: EnemyOffHandComponent = %WeaponShieldRelic
@onready var enemy_stats_compoment: EnemyStatsCompoment = %EnemyStatsCompoment
@onready var knock_back_component: KnockBackComponent = %KnockBackComponent
@onready var enemy_hurt_box_component: EnemyHurtBoxComponent = %EnemyHurtBoxComponent
@onready var enemy_drop_component: EnemyDropComponent = $EnemyDropComponent

@export var enemy_data: EnemyResource


var dead: bool = false


func _ready() -> void:
	pass

func setup(data: EnemyResource, level: int) -> void:
	if data == null:
		queue_free()
		return
	enemy_data = data
	enemy_level_component.set_level(level)
	enemy_init()
	enemy_level_component.emit_level()
	
func enemy_init() -> void:
	if enemy_data == null or not is_instance_valid(enemy_data):
		return
	enemy_visual_component.apply_visuals(enemy_data.enemy_mesh)
	enemy_main_hand_component.apply_mainhand_weapon_visual_data(enemy_data.weapon_data)
	weapon_shield_relic.apply_offhand_weapon_visual_data(enemy_data.weapon_data)
	enemy_animation_component.apply_animation_playback(enemy_data)
	enemy_stats_compoment.apply_enemy_stats(enemy_data.stats)
	ai_movement_component.apply_movement_data(enemy_data.movement_data, enemy_data.weapon_data)
	enemy_melee_combat_component.apply_melee_weapon_data(enemy_data.weapon_data)
	enemy_world_data_display.apply_world_display_data(enemy_data.name, enemy_level_component.level, enemy_data.max_health)
	enemy_health_component.apply_health_data(enemy_data.max_health, enemy_data.stats)
	enemy_drop_component.apply_drop_data(enemy_data.guaranteed_drop, enemy_data.randomDrop)
	if state_machine == null or not is_instance_valid(state_machine):
		return
	state_machine.Initializer()
func _on_ai_controller_component_target_in_attack_dist(status: bool) -> void:
	if dead:
		return
		
	if status: 
		state_machine.change_state("AttackState")
	else:
		state_machine.change_state("ChaseState")

func _on_enemy_health_component_dead() -> void:
	dead = true
	self.remove_from_group("enemies")
	self.add_to_group("dead_enemies")
	state_machine.change_state("DeathState")
	
	await get_tree().create_timer(1.0).timeout
	finished.emit(self)
	
func _on_ai_controller_component_wandering() -> void:
	if dead:
		return
	if state_machine:
		state_machine.change_state("WanderState")

func _on_ai_controller_component_idling() -> void:
	if dead:
		return
	if state_machine:
		state_machine.change_state("IdleState")

func _on_enemy_spawn_component_spawn() -> void:
	spawned.emit(self)
	if state_machine:
		state_machine.change_state("SpawnState")

func _on_hurt_box_area_entered(_area: Area3D) -> void:
	if dead:
		return
	if state_machine:
		state_machine.change_state("HurtState")

func reset_for_pool() -> void:
	dead = false
	remove_from_group("dead_enemies")
	add_to_group("enemies")
	
	velocity = Vector3.ZERO
	
	if despawn_timer:
		despawn_timer.stop()
	
	if state_machine:
		state_machine.change_state("IdleState")
	
func _on_de_spawn_timer_timeout() -> void:
	if dead:
		return
	finished.emit(self)
	queue_free()


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	if despawn_timer:
		despawn_timer.stop()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	if dead:
		return
	despawn_timer.start(20.0)
