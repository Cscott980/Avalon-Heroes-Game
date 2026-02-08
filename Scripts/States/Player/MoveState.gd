extends PlayerState

@export var run_attack_duration: float = 0.6 
var run_attack_time_left: float = 0.0

func enter() -> void:
	if player.is_dead:
		return 
	
	player.play_run_animation()
	
	
		
func exit() -> void:
	pass

func physics_process(delta: float) -> void:
	if player.is_dead:
		return

	var input_vec := Vector3.UP
	input_vec.z -= Input.get_action_strength("up")
	input_vec.z += Input.get_action_strength("down")
	input_vec.x -= Input.get_action_strength("left")
	input_vec.x += Input.get_action_strength("right")
	
	var dir = Vector3(input_vec.x, 0.0, input_vec.z )
	var speed = player.move_speed
	
	
	player.velocity.x = -dir.x * speed
	player.velocity.z = -dir.z * speed
	player.velocity.y -= player.world_gravity * delta
	
	player.face_direction(dir,delta)
	player.move_and_slide()
	
	if not player.is_moving() and not player.is_dead:
		state_machine.change_state("IdleState")


func handle_input(event: InputEvent) -> void:
	if player.input_locked:
		return
	if Input.is_action_pressed("base_attack") and not player.weapon_is_sheathed and not player.is_dead:
			state_machine.change_state("AttackState1")
	if event.is_action_pressed("ability_1") or event.is_action_pressed("ability_2") or event.is_action_pressed("ability_3") and not player.is_dead:
		state_machine.change_state("AbilityState")


func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy_weapon") or area.is_in_group("enemy_projectile") and not state_machine.is_attacking and not player.is_dead:
		state_machine.change_state("HurtState")
