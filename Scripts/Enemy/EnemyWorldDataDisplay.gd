class_name EnemyWorldDataDisplay extends Sprite3D

@onready var entity_name: Label = %Entity_Name
@onready var level: Label = %Level
@onready var health_bar: ProgressBar = %HealthBar
@onready var data_base: VBoxContainer = %DataBase

var max_health: int 

func _ready() -> void:
	pass

func apply_world_display_data(entity: String, entity_level: int, entity_health: int) -> void:
	entity_name.text = entity if entity != null else "Enemy"
	level.text = str(entity_level) if entity != null else "0"
	max_health = entity_health if entity_health != null else 10 #will spawn with only 10 health as max value
	health_bar.max_value = max_health
	health_bar.value = entity_health if entity_health != null else 5 #will spawn with half health active health.


func _on_enemy_level_component_current_level(data: int) -> void:
	level.text = str(data)

func _on_enemy_health_component_hit(current_amount: int) -> void:
	health_bar.value = current_amount


func _on_enemy_health_component_dead() -> void:
	data_base.visible = false


func _on_enemy_health_component_revived() -> void:
	data_base.visible = true
