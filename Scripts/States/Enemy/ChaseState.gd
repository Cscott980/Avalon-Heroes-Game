class_name ChaseState extends EnemyState

func enter() -> void:
	if enemy.enemy_health_component.is_dead:
		return
	playback.play_chase()

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
