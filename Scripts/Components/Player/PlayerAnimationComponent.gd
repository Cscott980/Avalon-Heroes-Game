@icon("uid://mobiykq2mgwg")
class_name PlyaerAnimationComponent extends Node

@export var anim_tree: AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = (anim_tree.get("parameters/Movement/playback"))


#--------- General -----------
func play_idle_animation() -> void:
	if playback:
		playback.travel("Idle")

func play_two_handed_animation() -> void:
	if playback:
		playback.travel("2_Handed_Weapom_Idle")

func play_run_animation() -> void:
	if playback:
		playback.travel("Run")

func play_death_animation() -> void:
	if playback:
		playback.travel("Death")

func play_hurt_animation() -> void:
	if playback:
		playback.travel("Hurt")

#--------- Melee Combat -----------
func play_1_handed_melee_attack_1_animation() -> void:
	if playback:
		playback.travel("1_Hand_Attack_1")

func play_1_handed_melee_attack_2_animation() -> void:
	if playback:
		playback.travel("1_Hand_Attack_2")

func play_1_handed_melee_attack_3_animation() -> void:
	if playback:
		playback.travel("1_Hand_Attack_3")

func play_2_handed_melee_attack_1_animation() -> void:
	if playback:
		playback.travel("2_Hand_Attack_1")

func play_2_handed_melee_attack_2_animation() -> void:
	if playback:
		playback.travel("2_Hand_Attack_2")

func play_2_handed_melee_attack_3_animation() -> void:
	if playback:
		playback.travel("2_Hand_Attack_3")

func play_dualwielding_melee_attack_1_animation() -> void:
	if playback:
		playback.travel("Dualwield_Attack_1")

func play_dualwielding_melee_attack_2_animation() -> void:
	if playback:
		playback.travel("Dualwield_Attack_2")

func play_dualwielding_melee_attack_3_animation() -> void:
	if playback:
		playback.travel("Dualwield_Attack_3")

#--------- Range Combat -----------

#--------- Shield -----------
