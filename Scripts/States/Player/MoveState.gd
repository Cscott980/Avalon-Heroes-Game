extends PlayerState

func enter() -> void:
	playback.play_run_animation()

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
