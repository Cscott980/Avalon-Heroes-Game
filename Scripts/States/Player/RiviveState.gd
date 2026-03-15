class_name ReviveState extends PlayerState

func enter() -> void:
	playback.play_revive_animation()
	player.immortal = true
	await get_tree().create_timer(1.5).timeout
	player.immortal = false

func exit() -> void:
	pass

func _physics_process(delta: float) -> void:
	if state_machine:
		state_machine.change_state("IdleState")
