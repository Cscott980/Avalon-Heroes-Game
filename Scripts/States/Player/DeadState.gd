extends PlayerState

func enter() -> void:
	player.play_death_animation()
	player.remove_from_group("player")

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
		player.is_dead = true
		player.is_getting_hit = false
		
		player.world_collision.set_deferred("disabled", true)
		player.hurt_collission.set_deferred("disabled", true)

func handle_input(_event: InputEvent) -> void:
	pass
