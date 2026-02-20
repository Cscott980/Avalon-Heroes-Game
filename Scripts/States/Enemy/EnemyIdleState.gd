class_name EnemyIdleState extends EnemyState

func enter() -> void:
	playback.play_idle()

func exit() -> void:
	pass

func physics_process(delta: float) -> void:
	pass
