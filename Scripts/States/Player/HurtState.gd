extends PlayerState
class_name HurtState

func enter() -> void:
	playback.play_hurt_animation()
	
func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
