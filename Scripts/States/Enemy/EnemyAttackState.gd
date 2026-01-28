extends EnemyState
class_name EnemyAttackState


func enter() -> void:
	enemy.enemy_attcak()
	
func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	if enemy.is_dead:
		return
	
	if enemy.current_target == null or not is_instance_valid(enemy.current_target) or enemy.current_target.is_dead:
		enemy.current_target = null
		state_machine.change_state("IdleState")
		return

	enemy.nav_agent.target_position = enemy.current_target.global_position
	var dist := enemy.global_position.distance_to(enemy.current_target.global_position)
	
	if dist > enemy.attack_range:
		state_machine.change_state("ChaseState")
		return
	
	enemy.velocity = Vector3.ZERO
	enemy.move_and_slide()
	
		


func _on_hurt_box_area_entered(area: Area3D) -> void:
	state_machine.change_state("HurtState")
