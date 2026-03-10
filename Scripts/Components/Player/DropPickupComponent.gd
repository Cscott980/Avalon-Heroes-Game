@icon("uid://crgj2opgpf4p4")
class_name DropPickUpComponent extends Node

signal health_potion(amount: float)
signal exp_gem(amount: int)
signal resource(amount: int)

@export var user: Player

var can_pick_up: bool = true

func _ready() -> void:
	can_pick_up = true

func pickup(drop_value: float, drop_type: int) -> void:
	if !is_instance_valid(user):
		return
	if not can_pick_up:
		return
	if user.health_component.is_dead:
		return
	if drop_type == ItemDropResource.DROP_TYPE.EXP_GEM:
		exp_gem.emit(int(drop_value))
	if  drop_type == ItemDropResource.DROP_TYPE.HEALTH_POT:
		if user.health_component.health < user.health_component.max_health:
			health_potion.emit(drop_value)
	if drop_type == ItemDropResource.DROP_TYPE.MANA_POT:
		if user.hero_class.resource_pool.resource_type == ResourcePoolResource.RESOURCE_TYPE.MANA:
			resource.emit(int(drop_value))
	if drop_type == ItemDropResource.DROP_TYPE.SCRAP:
		if user.hero_class.resource_pool.resource_type == ResourcePoolResource.RESOURCE_TYPE.SCRAP:
			resource.emit(int(drop_value))
	return

func _on_progression_component_leveling(status: bool) -> void:
	if status:
		can_pick_up = false
	else:
		can_pick_up = true
