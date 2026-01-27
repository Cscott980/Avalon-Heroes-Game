@icon("uid://b1r23qck8dqn7")
class_name AbilityComponent extends Node

signal cast_ability(animation: String, duration: float)
signal on_cooldown(button: Button, time: float, disable: bool)

@export var target: CharacterBody3D = null #Will get the class data from and populate the ability variables. via ready
#unlocks at level 10
var ability1: AbilityResource = null
#unlcoks at level 20
#reason for array is because some classes will be able 
#to chose from mutiple abilities for thier 2nd ability and then what they choose will be set to ability 2.
var ability2: Array[AbilityResource] = []
#unlocks at level 30, ULTIMATE ABILITY e.g.: [Earth Shatter]
var ability3: AbilityResource = null

func ability_2_chosen(selected_ability: int) -> void:
	if ability2[selected_ability]:
		var chosen:AbilityResource = ability2[selected_ability]
	pass
