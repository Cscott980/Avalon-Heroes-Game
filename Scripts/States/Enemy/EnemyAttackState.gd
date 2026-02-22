class_name EnemyAttackState extends EnemyState

@onready var attack_timer: Timer = %AttackCooldown

var target_in_range: bool

func enter() -> void:
	if target_in_range:
		do_attack()

func physics_process(_delta: float) -> void:
	if enemy.enemy_health_component.is_dead:
		attack_timer.stop()
		state_machine.change_state("DeathState")
		return

	var t := enemy.targeting_component.current_target
	if t == null or !is_instance_valid(t):
		attack_timer.stop()
		state_machine.change_state("WanderState")
		return

	if not target_in_range:
		attack_timer.stop()
		state_machine.change_state("ChaseState")
		return

func do_attack() -> void:
	playback.play_attack()
	attack_timer.start()

func _on_attack_cooldown_timeout() -> void:
	if target_in_range:
		do_attack()

func _on_ai_controller_component_target_in_attack_dist(status: bool) -> void:
	target_in_range = status


func _on_enemy_health_component_dead() -> void:
	target_in_range = false
