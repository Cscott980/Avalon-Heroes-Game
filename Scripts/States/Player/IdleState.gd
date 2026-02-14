extends PlayerState
class_name IdleState

var weapon_is_sheathed: bool 

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	state_machine.playback.play_idle_animation()
	
func handle_input(event: InputEvent) -> void:
	pass

func _on_player_input_component_sheath_weapon(sheath: bool) -> void:
	weapon_is_sheathed = sheath
