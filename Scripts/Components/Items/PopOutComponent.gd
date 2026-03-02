class_name PopOutComponent
extends Node

@export var item_base: RigidBody3D

func pop() -> void:
	
	if item_base == null:
		push_warning("PopOutComponent: item_base is null")
		return

	if not item_base.is_inside_tree():
		await item_base.tree_entered

	
	await get_tree().physics_frame
	
	await get_tree().physics_frame

	
	item_base.sleeping = false

	var force := Vector3(
		randf_range(-2.0, 2.0),
		10.0,
		randf_range(-2.0, 2.0)
	)

	item_base.apply_central_impulse(force)
