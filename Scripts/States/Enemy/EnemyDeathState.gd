class_name EnemyDeathState extends EnemyState

func enter() -> void:
	playback.play_death()

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
