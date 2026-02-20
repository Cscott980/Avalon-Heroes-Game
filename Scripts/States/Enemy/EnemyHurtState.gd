class_name EnemyHurtState extends EnemyState

func enter() -> void:
	playback.play_hurt()

func exit() -> void:
	pass

func physics_process(delta: float) -> void:
	pass
