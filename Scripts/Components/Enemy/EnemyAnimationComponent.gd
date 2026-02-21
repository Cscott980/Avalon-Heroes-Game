@icon("uid://du3eu82cceaog")
class_name EnemyAnimationComponent extends Node

@onready var anim_player: AnimationPlayer = %AnimationPlayer
@onready var anim_tree: AnimationTree = %AnimationTree
var playback: AnimationNodeStateMachinePlayback

var is_holding_2h: bool = false
var attack_animation: String

func apply_animation_playback(data: EnemyResource) -> void:
	anim_tree.tree_root = data.animation_tree
	var path_name = data.path_name
	playback = anim_tree.get("parameters/%s/playback" % path_name)

func play_idle() -> void:
	if playback:
		if is_holding_2h:
			playback.travel("Handed_Idle")
		else:
			playback.travel("Idle")

func play_chase() -> void:
	if playback:
		playback.travel("Chase")

func play_revive() -> void:
	if playback:
		playback.travel("Revive")

func play_death() -> void:
	if playback:
		var death_number = randi_range(1,3)
		if death_number == 1:
			playback.travel("Death_1")
		elif death_number == 2:
			playback.travel("Death_2")
		else:
			playback.travel("Death_3")

func play_attack() -> void:
	if playback:
		playback.travel(attack_animation)

func play_spawn() -> void:
	if playback:
		playback.travel("Spawn")

func play_wander() -> void:
	playback.travel("Wander")

func play_hurt() -> void:
	if playback:
		playback.travel("Hurt")

func _on_enemy_main_hand_component_handedness(hand: int) -> void:
	if hand == EnemyWeaponResource.HANDEDNESS.TWO_HANDED:
		is_holding_2h = true
	else:
		is_holding_2h = false

func _on_enemy_main_hand_component_attack_animation(anim: String) -> void:
	attack_animation = anim
