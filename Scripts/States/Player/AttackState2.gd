extends PlayerState
class_name Attack_State_2

var _queued_combo3: bool = false

func enter() -> void:
	_queued_combo3 = false
	if player.is_dead:
		return
	if player.weapon_is_sheathed:
		return
	if state_machine.combo_2_open:
		state_machine.is_attacking = true
		state_machine.combo_2_open = false
		state_machine.combo_3_open = true
		state_machine.attack_cooldown.stop()
		state_machine.attack_cooldown.wait_time = player.main_hand_weapon.weapon_attack_speed
		state_machine.attack_cooldown.start()
		state_machine.combo_timer.stop()
		state_machine.combo_timer.wait_time = 2.0
		state_machine.combo_timer.start()
		player.play_attack_2_animation()
	
func exit() -> void:
	pass

func _ready() -> void:
	pass

func physics_process(_delta: float) -> void:
	if player.is_dead:
		return

	if state_machine.attack_cooldown.is_stopped():
		state_machine.is_attacking = false
		
		if _queued_combo3:
			_queued_combo3 = false
			state_machine.change_state("AttackState3")
			return
		
		if player.is_moving():
			state_machine.change_state("MoveState")
		else:
			state_machine.change_state("IdleState")
		
		return
	
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("base_attack")and not state_machine.combo_timer.is_stopped():
		_queued_combo3 = true
	if not state_machine.is_attacking:
		if event.is_action_pressed("ability_1") or event.is_action_pressed("ability_2") or event.is_action_pressed("ability_3"):
			state_machine.change_state("AbilityState")
