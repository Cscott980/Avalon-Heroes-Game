extends PlayerState
class_name Attack_State_3

var _queued_combo1: bool = false

func enter() -> void:
	_queued_combo1 = false
	if player.is_dead:
		return
	if player.weapon_is_sheathed:
		return
	if state_machine.combo_3_open:
		state_machine.is_attacking = true
		state_machine.combo_3_open = false
		state_machine.combo_1_open = true
		state_machine.attack_cooldown.stop()
		state_machine.attack_cooldown.wait_time = 1.5
		state_machine.attack_cooldown.start()
		player.play_attack_3_animation()
	
func exit() -> void:
	pass

func _ready() -> void:
	pass

func physics_process(_delta: float) -> void:
	if player.is_dead:
		return
	
	if state_machine.attack_cooldown.is_stopped():
		state_machine.is_attacking = false
		
		state_machine.combo_1_open = true
		state_machine.combo_2_open = false
		state_machine.combo_3_open = false
		
		if player.is_moving():
			state_machine.change_state("MoveState")
		else:
			state_machine.change_state("IdleState")
	
func handle_input(event: InputEvent) -> void:
	if not state_machine.is_attacking:
		if event.is_action_pressed("ability_1") or event.is_action_pressed("ability_2") or event.is_action_pressed("ability_3"):
			state_machine.change_state("AbilityState")
