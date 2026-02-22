class_name WanderState extends EnemyState

func enter() -> void:
	if enemy.enemy_health_component.is_dead:
		return
	if not enemy.ai_movement_component._is_wandering:
		return
	playback.play_wander()

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
