extends Node
class_name PlayerState

@export var player: Player
@export var playback: PlayerAnimationComponent
@export var combat_comp: CombatComponent
@export var target_comp: TargetsInRangeComponent
@export var weap_equip_comp: WeaponEquipComponent

var state_machine: PlayerStateMachine

func enter() -> void:
	pass

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass
