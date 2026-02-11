extends PlayerState

func enter() -> void:
	player.play_run_animation()

func exit() -> void:
	pass

func physics_process(delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	pass
