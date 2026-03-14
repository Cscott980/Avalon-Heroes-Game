class_name EnemyDirector extends Node

signal enemy_killed

@onready var spawn_ring: SpawnRing = $SpawnRing
@onready var enemy_leveler: EnemyLeveler = $EnemyLeveler
@onready var budget_manager: BudgetManager = $BudgetManager
@onready var enemy_pool: EnemyPool = $EnemyPool
@onready var spawn_timer: Timer = $SpawnTimer

@export var world: Node3D

@export var spawn_attempts_per_tick: int = 1
@export var spawn_interval: float = 1.0
@export var enemy_level: int = 1

var start: bool = false

func _ready() -> void:
	enemy_leveler.get_world_level(world)
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()

func try_spawn_enemy() -> void:
	if not start:
		return
	if world == null or not is_instance_valid(world):
		return
		
	var enemy = enemy_pool.pick_resource(enemy_pool.enemies)
	if enemy == null:
		return
		
	var cost = enemy.cost
	if not budget_manager.can_spend(cost):
		return

	var new_enemy = enemy_pool.make_enemy()
	if new_enemy == null:
		return

	var spawn_pos = spawn_ring.get_spawn_position()
	if not is_finite(spawn_pos.x) or not is_finite(spawn_pos.y) or not is_finite(spawn_pos.z):
		return

	world.add_child(new_enemy)
	new_enemy.global_position = spawn_pos
	new_enemy.setup(enemy, enemy_level)

	budget_manager.spend(cost)
	
	if not new_enemy.finished.is_connected(_on_enemy_finished):
		new_enemy.finished.connect(_on_enemy_finished)
		
func _on_spawn_timer_timeout() -> void:
	for i in spawn_attempts_per_tick:
		try_spawn_enemy()

func _on_enemy_leveler_world_level(l: int) -> void:
	enemy_level = l

func _on_enemy_finished(enemy: Enemy) -> void:
	budget_manager.refund(enemy.enemy_data.cost)
	enemy_leveler.get_world_level(world)
	enemy_killed.emit()

func _on_game_manager_game_ended() -> void:
	start = false

func _on_game_manager_game_start() -> void:
	start = true

func _on_game_manager_frenzy(status: bool) -> void:
	if status:
		budget_manager.max_budget = budget_manager.base_budget * 3
	else:
		budget_manager.max_budget = budget_manager.base_budget
