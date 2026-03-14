class_name CameraEffect extends Camera3D

@export var shake_strength: float = 0.0
@export var shake_decay: float = 8.0
@export var player: Node3D
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

func move_to_mouse() -> Dictionary:
	var mouse_pos = get_viewport().get_mouse_position()
	
	var ray_origin: Vector3 = project_ray_origin(mouse_pos)
	var ray_end: Vector3 = ray_origin + project_ray_normal(mouse_pos) * 1000
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin,ray_end)
	
	if player:
		query.exclude = [player]
	
	var result : Dictionary = space_state.intersect_ray(query)
	
	if result:
		return {
			"hit": true,
			"position": result.position,
			"collider": result.collider
		}
		
	return {
			"hit": false,
			"position": Vector3.ZERO,
			"collider": null
		}
