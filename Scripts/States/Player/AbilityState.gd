extends PlayerState


var anility_data = FileAccess
var ability_cast_time: float

func enter() -> void:
	pass

func exit() -> void:
	if player.is_dead:
		return

func physics_process(_delta: float) -> void:
	# Grab the data base on the players class and process abilities when input is pressed
	
	if ability_cast_time <= 0.0:
		if not player.is_moving():
			state_machine.change_state("IdleState")
		if player.is_getting_hit:
			state_machine.change_state("HurtState")
		if player.is_moving():
			state_machine.change_state("MoveState")
		
		
			

func handle_input(event: InputEvent) -> void:
	if player.input_locked:
		return
	if ability_cast_time <= 0.0:
		if event.is_action_pressed("base_attack") and not player.weapon_is_sheathed:
			state_machine.change_state("AttackState1")
		
