class_name CameraEffect extends Camera3D

@export var shake_strength: float = 0.0
@export var shake_decay: float = 8.0
@export var player: Node3D

@export var pointer_effect: PackedScene

var original_position: Vector3


func _ready() -> void:
	original_position = position
	
func shake(amount: float) -> void:
	shake_strength = amount

func _process(delta: float) -> void:
	if shake_strength > 0:
		var offset = Vector3(
			randf_range(-1, 1),
			randf_range(-1, 1),
			0
		) * shake_strength

		position = original_position + offset

		shake_strength = lerp(shake_strength, 0.0, shake_decay * delta)
	else:
		position = original_position

func play_pointer_effect(pos: Vector3) -> void:
	if pointer_effect == null:
		return
	
	var point = pointer_effect.instantiate()
	player.get_parent().add_child(point)

	if point is Node3D:
		point.top_level = true
		point.global_position = pos + Vector3.UP * 0.2

	if point is CPUParticles3D:
		point.emitting = false
		point.restart()
		point.emitting = true

	print("spawned pointer at: ", point.global_position)

	await get_tree().create_timer(2.0).timeout
	if is_instance_valid(point):
		point.queue_free()

func move_to_mouse() -> Dictionary:
	var mouse_pos = get_viewport().get_mouse_position()
	
	var ray_origin: Vector3 = project_ray_origin(mouse_pos)
	var ray_end: Vector3 = ray_origin + project_ray_normal(mouse_pos) * 1000.0
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	
	if player:
		query.exclude = [player]
	
	var result: Dictionary = space_state.intersect_ray(query)
	
	if result:
		var collider = result.collider
		play_pointer_effect(result.position)
		
		return {
			"hit": true,
			"position": result.position,
			"collider": collider
		}
		
	return {
		"hit": false,
		"position": Vector3.ZERO,
		"collider": null
	}
