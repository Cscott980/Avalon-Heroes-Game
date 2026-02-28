class_name PopOutComponent extends Node

@export var item_base: Drop

func pop() -> void:
	var force = Vector3(
		randf_range(-2.0, 2.0), # Left/Right
		5.0,                   # Up
		randf_range(-2.0, 2.0)  # Forward/Back
	)
	item_base.apply_central_impulse(force)
