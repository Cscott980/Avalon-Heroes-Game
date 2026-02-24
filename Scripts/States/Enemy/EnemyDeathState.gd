class_name EnemyDeathState extends EnemyState

func enter() -> void:
	enemy.enemy_audio_component_2.stream = enemy.enemy_audio_component_2.get_random_death_sound()
	enemy.enemy_audio_component_2.play()
	playback.play_death()
	enemy.despawn_timer.wait_time = 10.0
	enemy.despawn_timer.start()
	
func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass


func _on_de_spawn_timer_timeout() -> void:
	enemy.queue_free()
