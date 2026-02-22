class_name EnemyIdleState extends EnemyState

func enter() -> void:
	if enemy.enemy_health_component.is_dead:
		return
	if enemy.ai_movement_component._is_wandering:
		return
	playback.play_idle()

func exit() -> void:
	pass

func physics_process(delta: float) -> void:
	pass
