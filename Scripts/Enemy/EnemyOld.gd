extends CharacterBody3D


@onready var player: CharacterBody3D
@onready var anim_tree: AnimationNodeStateMachinePlayback = %AnimationTree.get("parameters/OrcGruntAnim/playback")
@onready var hurt_box: Area3D = %HurtBox
@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var weapon: Node3D = %"Axe of The Barbarian"
@onready var world_collision: CollisionShape3D = %WorldCollision
@onready var enemy_health_bar: ProgressBar = %ProgressBar

#----- KNOCK BACK PROPERTIES ----

@export var knockback_stength: float = 6.0
@export var knockback_decay: float  = 20.0
var knockback_velocity: Vector3 = Vector3.ZERO

#--------------------------------

@export var player_path: NodePath
@export var enemy_speed: float = 3.0
@export var attack_range: float = 2.0
@export var enemy_health: int = 100
@export var enemy_damage: int = 5
@export var attack_speed: float = 0.5

var is_attacking: bool = false
var no_target: bool = false
var is_dead: bool = false
var is_getting_hit: bool = false

var health: int = 100

func  _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	health = enemy_health
	enemy_health_bar.value = health
	nav_agent.target_position = player.global_position

func _physics_process(delta: float) -> void:
	if player == null or not is_instance_valid(player) or no_target:
		return
	
	if is_attacking:
		if no_target:
			return
		if not is_on_floor():
			velocity.y -= gravity * delta
		move_and_slide()
		return
		
	if target_is_in_range():
		if no_target:
			return
		_start_attack()
		return
		
	nav_agent.target_position = player.global_position
	var next_point = nav_agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	
	velocity.x = direction.x * enemy_speed
	velocity.z = direction.z * enemy_speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
		
	if velocity.length() <= 0.1:
		anim_tree.travel("Idle")
	else:
		anim_tree.travel("Run")
	
	
	if knockback_velocity.length() > 0.05:
		velocity.x = knockback_velocity.x
		velocity.z = knockback_velocity.z
		knockback_velocity = knockback_velocity.move_toward(Vector3.ZERO, knockback_decay * delta)
		anim_tree.travel("Hit")
	else:
		knockback_velocity = Vector3.ZERO
	
	look_at(next_point, Vector3.UP)
	move_and_slide()

func _start_attack() -> void:
	if no_target:
		return
	if is_attacking:
		return
	is_attacking = true
	velocity = Vector3.ZERO
	anim_tree.travel("Attack")

func take_damage(amount: int) -> void:
	if is_dead:
		return
		
	if is_getting_hit:
		health -= amount
		#enemy_health_bar.value = health
		anim_tree.travel("Hit")
		
		var dir := (global_position - player.global_position).normalized()
		dir.y = 0.0
		
		knockback_velocity = dir * knockback_stength
		
		if health <= 0:
			anim_tree.travel("Death")
			health = 0
			velocity = Vector3.ZERO
			
			is_dead = true
			is_getting_hit = false
			
			world_collision.disabled = true
			hurt_box.disabled = true

func target_is_in_range() -> bool:
	return global_position.distance_to(player.global_position) <= attack_range
