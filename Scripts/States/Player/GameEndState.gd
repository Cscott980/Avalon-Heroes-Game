class_name GameEndState extends PlayerState

func enter() -> void:
	playback.play_cheer_animation()
	
func exit() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
