class_name ItemFloatComponent extends Node

@export_group("Item Visuals")
@export var model: MeshInstance3D

@export_group("Float Settings")
@export var time: float
@export var frquency: float #How fast it bobs
@export var amplitude: float #How high it bobs

func _process(delta: float) -> void:
	if not is_instance_valid(model):
		return
	
	time += delta * frquency
	
	var vertical_offset: float = sin(time) * amplitude
	
	model.position.y = vertical_offset
	
