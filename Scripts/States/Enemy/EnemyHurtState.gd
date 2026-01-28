extends EnemyState
class_name EnemyHurtState

var hit: bool

func enter() -> void:
	if enemy.is_dead:
		return
	hit = true
	enemy.hurt_cd.start()
	enemy.enemy_hit()
	
func exit() -> void:
	pass

func physics_process(delta: float) -> void:
	if enemy.is_dead:
		return
	if hit == false:
		if enemy.current_target != null:
			enemy._set_new_target()
			enemy.nav_agent.target_position = enemy.current_target.global_position
			enemy.velocity.y -= enemy.gravity * delta
			enemy.velocity = Vector3.ZERO
			state_machine.change_state("ChaseState")
			return
			
		if enemy.nav_agent.distance_to_target() <= enemy.attack_range and enemy.current_target != null:
			state_machine.change_state("AttackState")
			return
		
		
		if enemy.current_target == null or not is_instance_valid(enemy.current_target) or enemy.current_target.is_dead:
			state_machine.change_state("IdleState")
			return


func _on_hurt_cd_timeout() -> void:
	hit = false
