class_name EnemyDirector extends Node

signal spaw_enemy

@onready var spawn_ring: SpawnRing = $SpawnRing
@onready var enemy_pool: Node = $EnemyPool
@onready var enemy_leveler: Node = $EnemyLeveler
@onready var budget_manager: Node = $BudgetManager
@onready var spawn_timer: Timer = $SpawnTimer


@export var spawn_time: float = 5.0

func _ready() -> void:
	player_setter()

func player_setter() -> void:
	var active_player: Array[Node] = get_tree().get_nodes_in_group("player")
	for p in active_player:
		if p.is_in_group("dead"):
			continue
		if p in spawn_ring.players:
			continue
		spawn_ring.players.append(p)
