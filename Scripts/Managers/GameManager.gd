class_name GameManager extends Node

signal game_ended
signal game_start
signal frenzy(status: bool)

@onready var enemy_director: EnemyDirector = %EnemyDirector
@onready var quiz_manager: QuizManager = %QuizManager
@onready var session_timer: Timer = $SessionTimer
@onready var time: Label = %Time
@onready var game_end_screen: GameEndScene = %GameEndScreen

@export var session_time: float = 10.0
@export var frenzy_start_time: float = 5.0


var quiz_title: String = ""
var players: Array = []
var player_list: Array = []
var player_data: Dictionary = {}
var enemies_killed: int = 0

var frenzy_active: bool = false
var game_over: bool = false

func _ready() -> void:
	players = get_tree().get_nodes_in_group("player")
	for p in players:
		get_set_player_data(p)
		var player: Player = p
		
		if not player.drop_pickup_component.resource.is_connected(_on_drop_pickup_component_gold_picked_up):
			player.drop_pickup_component.resource.connect(_on_drop_pickup_component_gold_picked_up)
	session_timer.wait_time = get_time_in_seconds(session_time)
	session_timer.start()
	game_start.emit()

func get_set_player_data(entity: Player) -> void:
	player_data = {
		"id": 0,
		"gold": 0
	}
	player_data["id"] = entity.player_id
	player_data["gold"] = entity.player_ui.currency_comp.gold
	player_list.append(player_data)

func _process(_delta: float) -> void:
	if game_over:
		return
	if players.is_empty():
		return
	if enemy_director == null or not is_instance_valid(enemy_director):
		return
	if quiz_manager == null or not is_instance_valid(quiz_manager):
		return
	if time == null or not is_instance_valid(time):
		return
	
	time.text = format_time(session_timer.time_left)
	check_frenzy()
	
func check_frenzy() -> void:
	if frenzy_active:
		return
		
	if session_timer.time_left <= get_time_in_seconds(frenzy_start_time):
		start_frenzy()

func start_frenzy() -> void:
	frenzy_active = true
	frenzy.emit(true)

func format_time(seconds: float) -> String:
	var total_seconds: int = int(ceil(seconds))
	var minutes: int = total_seconds / 60
	var secs: int = total_seconds % 60
	return "%02d:%02d" % [minutes, secs]

func get_time_in_seconds(set_time: float) -> float:
	return float(set_time * 60)

func get_time_in_min(set_time: float) -> float:
	return set_time / 60

func _on_session_timer_timeout() -> void:
	game_ended.emit()
	game_over = true
	game_end_screen.play_cleared_animation()

func _on_enemy_director_enemy_killed() -> void:
	enemies_killed += 1

func _on_drop_pickup_component_gold_picked_up(amount: int) -> void:
	player_list[0]["gold"] += amount
