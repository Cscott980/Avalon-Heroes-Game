class_name EnemyDeathState extends EnemyState

func enter() -> void:
	enemy.despawn_timer.wait_time = 10.0
	enemy.despawn_timer.start()
	playback.play_death()

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass


func _on_de_spawn_timer_timeout() -> void:
	enemy.queue_free()
