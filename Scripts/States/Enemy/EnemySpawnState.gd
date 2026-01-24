extends EnemyState
class_name EnemySpawnState

func enter() -> void:
	
	enemy.enemy_spawn()
	
func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	
	await get_tree().create_timer(3.5).timeout
	if enemy.current_target:
		state_machine.change_state("ChaseState")
	else:
		state_machine.change_state("IdleState")
		
	if enemy.nav_agent.distance_to_target() <= enemy.attack_range:
		state_machine.change_state("AttackState")
	
