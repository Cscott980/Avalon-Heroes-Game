class_name ReviveState extends PlayerState

func enter() -> void:
	playback.play_revive_animation()

func exit() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
