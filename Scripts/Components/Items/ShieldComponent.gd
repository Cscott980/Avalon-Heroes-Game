class_name ShieldComponent extends Node3D
signal is_blocking(shield_value: int)
signal block_broke(cooldown: float)
@onready var block_box: Area3D = %BlockBox

@export var shield_data: ArmorResource
var value: int
var recharge: float
var inactive: bool = false

func _ready() -> void:
	if not shield_data.ArmorType.Shield or shield_data == null:
		return
	block_box.monitoring = false

func shield_init() -> void:
	pass
	
func activate_block() -> void:
	if inactive:
		return
	block_box.monitoring = true
	emit_signal("is_blocking", value)
	
func block_break() -> void:
	if value <= 0:
		emit_signal("block_broke", recharge)
		inactive = true
	
	
func _on_block_box_area_entered(area: Area3D) -> void:
	pass # Replace with function body.
