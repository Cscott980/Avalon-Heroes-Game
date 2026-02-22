class_name WorldCollision extends CollisionShape3D




func _on_health_component_dead() -> void:
	disabled = true


func _on_health_component_revived(owner: Node) -> void:
	disabled = false
