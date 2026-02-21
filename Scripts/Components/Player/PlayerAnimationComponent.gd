@icon("uid://mobiykq2mgwg")
class_name PlayerAnimationComponent extends Node

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var anim_tree: AnimationTree = %AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/Movement/playback")

var playback_name: String

func apply_animation_data(data: HeroClassResource) -> void:
	anim_tree.tree_root = data.playback
	playback_name = data.playback_name
	playback = anim_tree.get("parameters/%s/playback" % playback_name)

#--------- General -----------
func play_idle_animation() -> void:
	if playback:
		playback.travel("Idle")
		
func play_idle_bow_animation() -> void:
	if playback:
		playback.travel("Bow_Idle")
		
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

func play_attack_animation(animation: String) -> void:
	if playback:
		playback.travel(animation)

#--------- Range Combat -----------

#--------- Shield -----------
func play_standing_block() -> void:
	if playback:
		playback.travel("Shield_Blcok")

func play_walking_block() -> void:
	if playback:
		playback.travel("Walk_Shield_Block")

func play_standing_shield_hit() -> void:
	if playback:
		playback.travel("Shield_Hit")

func play_walking_shield_hit() -> void:
	if playback:
		playback.travel("Walk_Shield_Hit")

func play_block_shatter() -> void:
	if playback:
		playback.travel("Block_Shatter")

func _on_weapon_equip_component_is_dual_wielding(status: bool) -> void:
	pass # Replace with function body.
