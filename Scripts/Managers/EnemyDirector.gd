class_name EnemyDirector
extends Node

@export var spawn_attempts_per_tick := 1
@export var tier: StringName = &"grunt"
@export var enemy_level := 1

var world_root: Node3D
var spawn_ring: SpawnRing
var pool: EnemyPool
var leveler: EnemyLeveler
var budget: BudgetManager
var timer: Timer

func _ready() -> void:
	spawn_ring = SpawnRing.new()
	pool = EnemyPool.new()
	leveler = EnemyLeveler.new()
	budget = BudgetManager.new()

	# timer needs to be a node
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(_on_spawn_timer_timeout)

func configure(_world_root: Node3D, _enemy_base_scene: PackedScene, _enemies: Dictionary) -> void:
	world_root = _world_root
	pool.enemy_base_scene = _enemy_base_scene
	pool.enemies = _enemies
	pool._build_pool_keys()

func _on_spawn_timer_timeout() -> void:
	if world_root == null:
		return
	for _i in range(spawn_attempts_per_tick):
		_try_spawn_one()

func _try_spawn_one() -> void:
	var res: EnemyResource = pool.pick_resource(tier)
	if res == null:
		return

	var cost: int = budget.get_cost(tier)
	if not budget.can_spend(cost):
		return

	var pos := spawn_ring.get_spawn_position()
	if pos == SpawnRing.INVALID_POS:
		return

	var enemy: Enemy = pool.take(res)
	if enemy == null:
		return

	world_root.add_child(enemy)
	enemy.global_position = pos

	enemy.setup(res, enemy_level)
	enemy.activate_spawn()

	leveler.apply(enemy)
	budget.spend(cost)

	enemy.finished.connect(func(_e: Enemy):
		budget.refund(cost)
		pool.release(res, enemy)
	, CONNECT_ONE_SHOT)
