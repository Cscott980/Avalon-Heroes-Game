extends PlayerState



func enter() -> void:
	state_machine.playback.play_death_animation()
	player.remove_from_group("player")
	player.add_to_group("dead_players")

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	player.world_collision.set_deferred("disabled", true)
	state_machine.change_state("QuizState")
