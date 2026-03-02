@icon("uid://bhgfggrpib6sa")
class_name ResourcePoolComponent extends Node

signal current_resource_amount(amount: int)
signal resource_data(data: ResourcePoolResource)
signal resource_used(amount: int)
signal resource_gain(amount: int)


var hero_class: int

var resource_type: int
var resource_amount: int
var resource_max_value: int
var rersource_color_bar: Color
var regen: float
var delay: float
var style_bar: StyleBox
var regen_method: int

func _ready() -> void:
	pass

func apply_resource_data(data: ResourcePoolResource, hero_type: int) -> void:
	resource_type = data.resource_type
	resource_amount = data.start_value
	resource_max_value = data.max_value
	style_bar = data.style_bar
	regen = data.regen_rate
	delay = data.regen_rate
	regen_method = data.gain_conditions
	hero_class = hero_type
	resource_data.emit(data)

func generate_resource(amount: int) -> void:
	if resource_amount < resource_max_value:
		resource_amount += amount
		current_resource_amount.emit(resource_amount)

func _on_drop_pickup_component_resource(amount: int) -> void:
	generate_resource(amount)


func _on_main_hand_weapon_weapon_hit(_area: Area3D) -> void:
	if hero_class == HeroClassConstants.HERO_CLASS.WARRIOR:
		var gain: int =  5
		generate_resource(gain)

func _on_off_hand_weapon_weapon_hit(area: Area3D) -> void:
	if hero_class == HeroClassConstants.HERO_CLASS.WARRIOR:
		var gain: int =  5
		generate_resource(gain)
