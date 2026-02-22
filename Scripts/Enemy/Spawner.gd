class_name Spawner extends Node3D


@export var spawn_time: float
@onready var spawn_timer: Timer = %SpawnTimer
@onready var enemy_container: Node3D = %NavigationRegion3D/Enemies
var players: Array = []
var active_players: Array = []




const ENEMY_GRUNT = preload("res://Scenes/Enemeies/Enemy.tscn")
var new_enemy: CharacterBody3D = null

func _ready() -> void:
	spawn_timer.wait_time = spawn_time
	players = get_tree().get_nodes_in_group("player")
	
	for player in players:
		active_players.append(player)
	
func _process(_delta: float) -> void:
	if active_players.is_empty():
		spawn_timer.stop()
		return
	check_player_status()
	
func _on_spawn_timer_timeout() -> void:
	new_enemy = ENEMY_GRUNT.instantiate()
	enemy_container.add_child(new_enemy)
	new_enemy.global_position = global_position
	spawn_timer.wait_time = randf_range(1,10)
	
func check_player_status() -> void:
	if active_players.is_empty():
		return
	
	for p in active_players:
		if p.has_node("HealthComponent") and p is Player:
			var health_status = p.get_node("HealthComponent") as HealthComponent
			if health_status.is_dead:
				active_players.erase(p)
