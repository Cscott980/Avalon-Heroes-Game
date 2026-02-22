extends PlayerState
class_name HurtState

func enter() -> void:
	if player.movement_component.is_moving():
		playback.play_running_hurt_animation()
	else:
		playback.play_hurt_animation()
	
func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
