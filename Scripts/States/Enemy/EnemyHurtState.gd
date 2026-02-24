class_name EnemyHurtState extends EnemyState

func enter() -> void:
	enemy.enemy_audio_component.stream = preload("uid://ct86p1ebxcvrj")
	enemy.enemy_audio_component.play()
	enemy.enemy_audio_component_2.stream = enemy.enemy_audio_component_2.get_random_hit_sound()
	enemy.enemy_audio_component_2.play()
	playback.play_hurt()
	
	if enemy.enemy_health_component.is_dead:
		state_machine.change_state("DeathState")
	
func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
