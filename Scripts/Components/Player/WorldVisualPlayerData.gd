class_name WorldVisualPlayerData extends Sprite3D

@onready var player_name: Label = %PlayerName
@onready var level_display: Label = %LevelDisplay
@onready var health_bar: ProgressBar = %HealthBar


@export var max_health = 100

var health: int


func apply_player_visual_data(player: String, level: int) -> void:
	player_name.text = player
	level_display.text = str(level)
	
func apply_player_health_visual_data(health: int) -> void:
	max_health = health
	health_bar.max_value = max_health
	health = max_health
	health_bar.value = health
	
func _on_health_component_current_health(amount: int, max_player_health: int) -> void:
	health_bar.value = amount
	health_bar.max_value = max_player_health
