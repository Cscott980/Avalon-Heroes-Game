class_name DeathState extends PlayerState

func enter() -> void:
	playback.play_death_animation()

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
