class_name WanderState extends EnemyState

func enter() -> void:
	playback.play_wander()

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
