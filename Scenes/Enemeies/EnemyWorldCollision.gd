extends CollisionShape3D

@export var enemy: Enemy

const ENEMY_COLLISION: String = "uid://doxifox4gj5jn"

func _dead_enemy() -> void:
	self.shape = null
	
func _revived() -> void:
	self.shape = preload(ENEMY_COLLISION)

func _on_enemy_health_component_dead() -> void:
	_dead_enemy()
