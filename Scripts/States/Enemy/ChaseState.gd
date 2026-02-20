class_name ChaseState extends EnemyState

func enter() -> void:
	playback.play_chase()

func exit() -> void:
	pass

func physics_process(delta: float) -> void:
	pass
