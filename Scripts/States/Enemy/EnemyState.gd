extends Node
class_name EnemyState

@export var playback: EnemyAnimationComponent

var enemy: Enemy
var state_machine: EnemyStateMachine

func enter() -> void:
	pass

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
