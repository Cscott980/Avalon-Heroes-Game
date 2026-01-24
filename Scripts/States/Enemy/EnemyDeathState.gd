extends EnemyState
class_name EnemyDeathState

func enter() -> void:
	enemy.world_collision.set_deferred("disabled", true)
	enemy.hurt_box.set_deferred("monitoring", false)
	enemy.enemy_death()
	queue_free()


func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
