@icon("uid://bhgfggrpib6sa")
class_name ResourcePoolComponent extends Node

signal current_resource_amount(amount: int)
signal resource_used(amount: int)

var resource_data:ResourcePoolResource

var resource_type: int
var resource_amount: int
var resource_max_value: int
var rersource_color_bar: Color
var regen: float
var delay: float

func apply_resource_data(data: ResourcePoolResource) -> void:
	resource_type = data.resource_type
	resource_amount = data.start_value
	resource_max_value = data.max_value
	regen = data.regen_rate
	delay = data.regen_rate
