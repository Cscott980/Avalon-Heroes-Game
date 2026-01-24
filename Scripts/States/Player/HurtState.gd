extends PlayerState
class_name HurtState

func enter() -> void:
	if state_machine.is_attacking:
		return
	player.is_getting_hit = true
	
	if player.is_dead:
		return
	
	player.play_hurt_animation()
	
	if player.is_moving():
		player.play_hurt_run_animation()

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	
	if player.is_moving():
		state_machine.change_state("MoveState")
	else: 
		state_machine.change_state("IdleState")
	if player.health == 0:
		state_machine.change_state("DeadSate")

func handle_input(event: InputEvent) -> void:
	if Input.is_action_pressed("base_attack") and not player.weapon_is_sheathed:
		state_machine.change_state("AttackState1")
	if event.is_action_released("ability_1") or event.is_action_released("ability_2") or event.is_action_released("ability_3"):
		state_machine.change_state("AbilityState")
	
