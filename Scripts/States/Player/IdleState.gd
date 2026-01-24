extends PlayerState
class_name IdleState


func enter() -> void:
	if player.is_dead:
		return
	
func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	var input_vec := Vector3.ZERO
	input_vec.z -= Input.get_action_strength("up")
	input_vec.z += Input.get_action_strength("down")
	input_vec.x -= Input.get_action_strength("left")
	input_vec.x += Input.get_action_strength("right")
	
	player.play_idle_animation()
	
	if input_vec.length() > 0.1:
		state_machine.change_state("MoveState")
	
func handle_input(event: InputEvent) -> void:
	if player.input_locked:
		return
	if Input.is_action_pressed("base_attack") and not player.weapon_is_sheathed and not player.is_dead:
		state_machine.change_state("AttackState1")
	if event.is_action_pressed("ability_1") or event.is_action_pressed("ability_2") or event.is_action_pressed("ability_3"):
		state_machine.change_state("AbilityState")
	


func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy_weapon") or area.is_in_group("enemy_projectile") and not state_machine.is_attacking and not player.is_dead:
		state_machine.change_state("HurtState")
