class_name EnemyDirector extends Node

@onready var spawn_ring: SpawnRing = $SpawnRing
@onready var enemy_leveler: EnemyLeveler = $EnemyLeveler
@onready var budget_manager: BudgetManager = $BudgetManager
@onready var enemy_pool: EnemyPool = $EnemyPool
@onready var spawn_timer: Timer = $SpawnTimer

@export var world: Node3D
@export var nav_root: Node3D

@export var spawn_attempts_per_tick: int = 1
@export var spawn_interval: float = 1.0
@export var enemy_level: int = 1



func _ready() -> void:
	enemy_leveler.get_world_level(world)
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()

func try_spawn_enemy() -> void:
	if nav_root == null or not is_instance_valid(nav_root):
		return
	if world == null or not is_instance_valid(world):
		return
		
	var enemy = enemy_pool.pick_resource(enemy_pool.enemies)
	
	if enemy == null:
		return
		
	var cost = enemy.cost
	if budget_manager.can_spend(cost):
		budget_manager.spend(cost)
		var new_enemy = enemy_pool.make_enemy()
		nav_root.add_child(new_enemy)
		new_enemy.global_position = spawn_ring.get_spawn_position()
		new_enemy.setup(enemy,enemy_level)
		
func _on_spawn_timer_timeout() -> void:
	for i in spawn_attempts_per_tick:
		try_spawn_enemy()

func _on_enemy_leveler_world_level(l: int) -> void:
	enemy_level = l


func _on_enemy_spawned(enemy: Enemy) -> void:
	pass # Replace with function body.


func _on_enemy_finished(enemy: Enemy) -> void:
	budget_manager.refund(enemy.enemy_data.cost)
	enemy_leveler.get_world_level(world)
