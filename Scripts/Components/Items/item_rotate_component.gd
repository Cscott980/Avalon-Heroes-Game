class_name ItemRotateComponent extends Node

@export var model: MeshInstance3D
@export var rotation_speed_deg: float

func _process(delta: float) -> void:
	
	model.rotate_y(deg_to_rad(rotation_speed_deg)*delta)
