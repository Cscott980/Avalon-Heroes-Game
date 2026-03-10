@icon("uid://duluysakx5ncb")
class_name WorldVisualPlayerData extends Sprite3D

@onready var player_name: Label = %PlayerName
@onready var level_display: Label = %LevelDisplay
@onready var health_bar: ProgressBar = %HealthBar

@export var max_health = 100
var health: int = 100

func apply_player_visual_data(player: String, level: int) -> void:
	player_name.text = player
	level_display.text = str(level)	
	
func apply_player_health_visual_data(data: int) -> void:
	max_health = data
	health_bar.max_value = max_health  # ← max first
	health = max_health
	health_bar.value = health
	
	
func _on_health_component_current_health(amount: int, max_player_health: int) -> void:
	max_health = max_player_health
	health = amount
	health_bar.value = health
	health_bar.max_value = max_health


func _on_health_component_leveled_health(maxh: int) -> void:
	max_health = maxh
	health = maxh
	health_bar.max_value = max_health  # ← set max FIRST
	health_bar.value = health           # ← then set value
	print(health_bar.value)
	
