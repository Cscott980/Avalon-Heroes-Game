extends PlayerState
class_name IdleState


func enter() -> void:
	player.play_idle_animation()
	
func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
	
func handle_input(event: InputEvent) -> void:
	pass
