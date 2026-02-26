class_name CameraEffect extends Camera3D

@export var shake_strength: float = 0.0
@export var shake_decay: float = 8.0

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
		
