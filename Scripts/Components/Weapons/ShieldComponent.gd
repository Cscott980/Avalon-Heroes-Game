class_name ShieldComponent extends Node3D
signal is_blocking(shield_value: int)
signal block_broke(cooldown: float)


@onready var block_box: Area3D = %BlockBox
@onready var cooldown: Timer = $Cooldown

@export var shield_data: ArmorResource
@export var max_value: int
var value: int
var recharge: float
var inactive: bool = false
var shield_ready: bool

func _ready() -> void:	
	block_box.monitoring = false
	value = max_value
	

func shield_init() -> void:
	if not shield_data.ArmorType.Shield:
		return
	max_value = shield_data.shield_block_value
	recharge = shield_data.shield_cooldown
	
func activate_block() -> void:
	if inactive:
		return
	inactive = true
	block_box.monitoring = true
	emit_signal("is_blocking", value)
	
func deactivate_block() -> void:
	if not inactive:
		return
	inactive = true
	block_box.monitoring = false
	emit_signal("stop_blocking", recharge)
	
func block_break() -> void:
	if value <= 0:
		inactive = true
		shield_ready = false
		emit_signal("block_broke", recharge)
	
func block_damage(damage: int) -> void:
	if not shield_ready:
		return
	if value <= 0:
		block_break()
		return
	value -= damage
	


func _on_block_box_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy_projectile") or area.is_in_group("enemy_weapon"):
		#TODO: Finish logic for blocking 
		pass


func _on_cooldown_timeout() -> void:
	shield_ready = true


func _on_player_input_component_block() -> void:
	if not inactive and shield_ready:
		activate_block()
	
func _on_player_input_component_not_blocking() -> void:
	if inactive:
		deactivate_block()
