class_name EnemyHurtState extends EnemyState

func enter() -> void:
	playback.play_hurt()

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
