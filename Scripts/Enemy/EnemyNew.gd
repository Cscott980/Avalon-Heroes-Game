extends CharacterBody3D


#-------- Visuals ---------
@onready var skeleton_minion_arm_left: MeshInstance3D = %Skeleton_Minion_ArmLeft
@onready var skeleton_minion_arm_right: MeshInstance3D = %Skeleton_Minion_ArmRight
@onready var skeleton_minion_body: MeshInstance3D = %Skeleton_Minion_Body
@onready var skeleton_minion_cloak: MeshInstance3D = %Skeleton_Minion_Cloak
@onready var skeleton_minion_head: MeshInstance3D = %Skeleton_Minion_Head
@onready var skeleton_minion_leg_left: MeshInstance3D = %Skeleton_Minion_LegLeft
@onready var skeleton_minion_leg_right: MeshInstance3D = %Skeleton_Minion_LegRight
@onready var weapon_mesh: MeshInstance3D = %WeaponMesh
@onready var weapon_shield_relic: MeshInstance3D = %WeaponShieldRelic

@onready var highlight: Material = preload("uid://cfrxegokeyufx")
@onready var state_machine: EnemyStateMachine = %EnemyStateMachine
@onready var hit_box: Area3D = %HitBox
@onready var world_collision: CollisionShape3D = %WorldCollision
@onready var hurt_box: Area3D = %HurtBox
@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var anim_tree: AnimationTree = %AnimationTree
@onready var anim_state: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/EnemyAnimations/playback")
@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var enemy_health_bar: ProgressBar = %EnemyHealthBar
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_cd: Timer = %HurtCD

@export var enemy_list: EnemyDataManager.ENEMY_TYPE
@export var level: int = 1
@export var turn_speed: float = 4.0
var targets: Array = []
var current_target: Node3D = null
var enemy_data: Dictionary = {}
var enemy_type = ""

var skin_list: Array = []

var health: int = 100
var attack_range: float = 2.0
var attack_speed: float = 1.0
var move_speed: float = 1.0
var damage: int = 1
var is_attacking: bool = false
var is_dead: bool = false

func _ready() -> void:
	targets = get_tree().get_nodes_in_group("player")
	call_deferred("_init_enemy")
	
	skin_list = [
		skeleton_minion_arm_left,
		skeleton_minion_arm_right,
		skeleton_minion_body,
		skeleton_minion_cloak,
		skeleton_minion_head,
		skeleton_minion_leg_left,
		skeleton_minion_leg_right,
		weapon_mesh,
		weapon_shield_relic,
	]
	highlighter_off()

func _load_stats_from_db() -> void:
	enemy_type = EnemyData.load_enemy_id(enemy_list) #Convert the selected type to its ID to search in the enemy database.
	enemy_data = EnemyData.enemy_data_base.get(enemy_type,{}) #Fetch the data for the enemy type
	health = enemy_data.get("health", 0) #Get enemy health from enemy database
	enemy_health_bar.max_value = health
	enemy_health_bar.value = health #Display health bar with max health. Updates as enemy levels.
	move_speed = enemy_data.get("move_speed", 0.0) #Set enemy base speed from DB.
	attack_speed = enemy_data.get("attack_speed", 1.0)
	damage = enemy_data.get("damage", 0) #Set Base damage from DB.

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	_set_new_target()
	if current_target == null:
		velocity = Vector3.ZERO
		enemy_idle()
		move_and_slide()
		return
	
	nav_agent.target_position = current_target.global_position
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if nav_agent.distance_to_target() <= attack_range:	
		velocity = Vector3.ZERO
		enemy_attcak()
		move_and_slide()
		return
	
	var next_point = nav_agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	
	velocity.x = direction.x * move_speed 
	velocity.z = direction.z * move_speed
	
	look_at(current_target.global_position, Vector3.UP)
	rotate_y(deg_to_rad(rotation.y * turn_speed))

	move_and_slide()

func _set_new_target() -> void:
	if is_dead:
		return
	
	targets = get_tree().get_nodes_in_group("player")
	
	var closest = null
	var best_dis: float = INF
	
	for p in targets: 
		if p == null or !is_instance_valid(p):
			continue
		var d := global_position.distance_to(p.global_position)
		if d < best_dis:
			best_dis = d
			closest = p
	current_target = closest

func _init_enemy() -> void:
	_set_new_target()
	_load_stats_from_db()

func target_in_range() -> bool:
	if current_target == null or !is_instance_valid(current_target):
		return false
		
	return global_position.distance_to(current_target.global_position) <= attack_range

func recalculate_stats(_level: int) -> int:
	return 0

func level_up(_world_level: int) -> void:
	pass

func take_damage(amount: int) -> void:
	health -= amount
	enemy_health_bar.value = health
	state_machine.change_state("EnemyHurtState")
	
	if health <= 0:
		health = 0
		is_dead = true
		state_machine.change_state("EnemyDeathState")

func highlighter_on() -> void:
	for mesh in skin_list:
		mesh.material_overlay = highlight

func highlighter_off() -> void:
	for mesh in skin_list:
		mesh.material_overlay = null

#------- Animation Functions -------
func enemy_idle() -> void:
	anim_state.travel("Idle")
func enemy_spawn() -> void:
	anim_state.travel("Spawn")
func enemy_hit() -> void:
	anim_state.travel("Hit")
func enemy_chase() -> void:
	anim_state.travel("Chase")
func enemy_death() -> void:
	anim_state.travel("Death")
func enemy_revive() -> void:
	anim_state.travel("Revive")
func enemy_attcak() -> void:
	anim_state.travel("MeleeAttack")
