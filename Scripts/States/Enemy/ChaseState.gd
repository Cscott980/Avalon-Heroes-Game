extends EnemyState
class_name ChaseState


@export var repath_distance: float = 0.75
var _last_target_pos := Vector3.INF



func enter() -> void:
	if enemy.is_dead:
		return
	_last_target_pos = Vector3.INF
	enemy.target_position_timer.start()

func exit() -> void:
	if enemy.target_position_timer:
		enemy.target_position_timer.stop()

func physics_process(delta: float) -> void:
	if enemy.is_dead:
		return
		
	enemy.nav_agent.target_position = enemy.current_target.global_position
	enemy.velocity.y -= enemy.gravity * delta
	
	var next_point: Vector3 = enemy.nav_agent.get_next_path_position()
	var direction = next_point - enemy.global_position
	direction.y = 0
	
	if direction.length() > 0.01:
		direction = direction.normalized()
		enemy.velocity.x = direction.x * enemy.move_speed 
		enemy.velocity.z = direction.z * enemy.move_speed
	
		enemy.look_at(enemy.current_target.global_position, Vector3.UP)
		enemy.rotate_y(deg_to_rad(enemy.rotation.y * enemy.turn_speed))
	
	enemy.enemy_chase()
	enemy.move_and_slide()
	
	if enemy.current_target == null or not is_instance_valid(enemy.current_target) or enemy.current_target.is_dead:
		enemy.current_target = null
		state_machine.change_state("IdleState")
		return
		
	if enemy.nav_agent.distance_to_target() <= enemy.attack_range:
		state_machine.change_state("AttackState")
	
	if enemy.player_list.is_empty():
		state_machine.change_state("IdleState")

func _on_target_position_timer_timeout() -> void:
	enemy._set_new_target()
	
	if enemy.current_target == null or not is_instance_valid(enemy.current_target) or enemy.current_target.is_dead:
		return
	var p := enemy.current_target.global_position
	
	if _last_target_pos != Vector3.INF and _last_target_pos.distance_to(p) < repath_distance:
		return
	
