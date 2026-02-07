extends Area3D
class_name HitBox

var enemy: Enemy

func _set_damage(value: int):
	enemy.damage = value
	
func _get_damage() -> int:
	return enemy.damage
