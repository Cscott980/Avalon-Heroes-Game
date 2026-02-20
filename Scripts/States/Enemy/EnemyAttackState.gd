class_name EnemyAttackState extends EnemyState

func enter() -> void:
	playback.play_attack()

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
