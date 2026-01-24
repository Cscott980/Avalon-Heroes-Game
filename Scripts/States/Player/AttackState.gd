extends PlayerState
class_name Attack_State_1

@export var step_in_distance: float = 1.2 #how close I want to end up
@export var step_in_speed: float = 10.0 #how fast i want to step in
@export var max_step_time: float = 0.15 #keep it snappy

@export var turn_speed: float = 14.0 
@export var face_target_while_attacking: bool = true

var _step_target_pos: Vector3
var _step_timer: float = 0.0
var _do_step: bool = false

var _queued_combo2: bool = false

func enter() -> void:
	_queued_combo2 = false
	if player.is_dead:
		return
		
	if player.main_hand_weapon.WEAPON_TYPE == null and player.off_hand_weapon.WEAPON_TYPE == null:
		return
		
	if player.current_target == null or not is_instance_valid(player.current_target):
		_do_step = false
		
	if player.current_target:
		var t: Node3D = player.current_target
		
		var dir := (player.global_position - t.global_position)
		dir.y = 0
		if dir.length_squared() < 0.0001:
			_do_step = false
		else:
			dir = dir.normalized()
			_step_target_pos = t.global_position + dir * step_in_distance
			_step_timer = 0.0
			_do_step = true

	if state_machine.combo_1_open:
		state_machine.is_attacking = true
		state_machine.combo_1_open = false
		state_machine.combo_2_open = true
		state_machine.attack_cooldown.stop()
		state_machine.attack_cooldown.wait_time = player.main_hand_weapon.weapon_attack_speed
		state_machine.attack_cooldown.start()
		state_machine.combo_timer.stop()
		state_machine.combo_timer.wait_time = 2.0
		state_machine.combo_timer.start()
		player.play_attack_1_animation()
	
func exit() -> void:
	pass
func _ready() -> void:
	pass

func physics_process(delta: float) -> void:
	if player.input_locked:
		return
	if player.is_dead:
		return
	
	if player.current_target != null and is_instance_valid(player.current_target):
		var dir := player.current_target.global_position - player.global_position
		player.face_direction(-dir, delta)
		
	if state_machine.attack_cooldown.is_stopped():
		state_machine.is_attacking = false
		
		if _queued_combo2:
			_queued_combo2 = false
			state_machine.change_state("AttackState2")
			return
		
		if player.is_moving():
			state_machine.change_state("MoveState")
		else:
			state_machine.change_state("IdleState")
			
		return
			
	if _do_step:
		_step_timer += delta
		var to := _step_target_pos - player.global_position		
		to.y = 0
		
	
		if to.length() < 0.05 or _step_timer >= max_step_time:
			_do_step = false
			player.velocity.x = 0
			player.velocity.z = 0
			
		else:
			var desired_vel := to.normalized() * step_in_speed
			player.velocity.x = desired_vel.x
			player.velocity.z = desired_vel.z
			
		player.move_and_slide()

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("base_attack") and not state_machine.combo_timer.is_stopped():
		_queued_combo2 = true
			
	if not state_machine.is_attacking:
		if event.is_action_pressed("ability_1") or event.is_action_pressed("ability_2") or event.is_action_pressed("ability_3"):
			state_machine.change_state("AbilityState")
