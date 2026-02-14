extends PlayerState

func enter() -> void:
	pass
func exit() -> void:
	pass
func physics_process(delta: float) -> void:
	state_machine.playback.play_run_animation()
func handle_input(event: InputEvent) -> void:
	pass
