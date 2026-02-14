extends Node
class_name PlayerState

var player: Player
@export var playback: PlayerAnimationComponent
var state_machine: PlayerStateMachine

func enter() -> void:
	pass

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass
