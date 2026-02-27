class_name DropPickUpComponent extends Node

signal health_potion(amount: int)
signal exp_gem(amount: int)
signal resource(amount: int)

@export var user: Player

var can_pick_up: bool = true

func pick_up(drop_value: int, drop_type: int) -> void:
	if !is_instance_valid(user):
		return
	if drop_type == ItemDropResource.DROP_TYPE.EXP_GEM:
		can_pick_up = true
		exp_gem.emit(drop_value)
	if  drop_type == ItemDropResource.DROP_TYPE.HEALTH_POT:
		if user.health_component.health < user.health_component.max_health:
			can_pick_up = true
			health_potion.emit(drop_value)
	if drop_type == ItemDropResource.DROP_TYPE.MANA_POT:
		if user.hero_class.resource_pool.resource_type == ResourcePoolResource.RESOURCE_TYPE.MANA:
			can_pick_up = true
			resource.emit(drop_value)
	if drop_type == ItemDropResource.DROP_TYPE.SCRAP:
		if user.hero_class.resource_pool.resource_type == ResourcePoolResource.RESOURCE_TYPE.SCRAP:
			can_pick_up = true
			resource.emit(drop_value)
	
	return
