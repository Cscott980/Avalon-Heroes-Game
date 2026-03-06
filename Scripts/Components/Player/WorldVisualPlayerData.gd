@icon("uid://duluysakx5ncb")
class_name WorldVisualPlayerData extends Sprite3D

@onready var player_name: Label = %PlayerName
@onready var level_display: Label = %LevelDisplay
@onready var health_bar: ProgressBar = %HealthBar


@export var max_health = 100

var health: int

func _clamp_health() -> void:
	health = clamp(health, 0, max_health)

func apply_player_visual_data(player: String, level: int) -> void:
	player_name.text = player
	level_display.text = str(level)
	
func apply_player_health_visual_data(health: int) -> void:
	max_health = health
	health_bar.max_value = max_health
	health = max_health
	health_bar.value = health
	
func _on_health_component_current_health(amount: int, max_player_health: int) -> void:
	var safe_value :int = clamp(amount, 0, max_player_health)
	health_bar.value = float(safe_value)
	health_bar.max_value = float(max_player_health)
