extends EnemyState
class_name EnemyIdleState

func enter() -> void:
	enemy.enemy_idle()
	enemy.velocity = Vector3.ZERO
	enemy.move_and_slide()
	
func exit() -> void:
	if enemy.target_position_timer:
		enemy.target_position_timer.stop()


func physics_process(delta: float) -> void:
	if enemy.is_dead:
		return

	enemy.velocity.y -= enemy.gravity * delta
	enemy.velocity = Vector3.ZERO
	enemy.move_and_slide()
	
	if enemy.current_target == null or not is_instance_valid(enemy.current_target) or enemy.current_target.is_dead:
		enemy.current_target = null
		return
	
	if enemy.nav_agent.distance_to_target() <= enemy.attack_range:
		state_machine.change_state("AttackState")
	else:
		state_machine.change_state("ChaseState")


func _on_target_position_timer_timeout() -> void:
	if enemy.current_target == null or not is_instance_valid(enemy.current_target) or enemy.current_target.is_dead:
		enemy._set_new_target()
