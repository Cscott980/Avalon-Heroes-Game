class_name WanderState extends EnemyState

func enter() -> void:
	playback.play_wander()
	await get_tree().create_timer(1.0).timeout
	enemy.targeting_component._set_new_target()

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
