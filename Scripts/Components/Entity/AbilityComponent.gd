@icon("uid://d1kvwucvgso6m")
class_name AbilityComponent extends Node

signal cast_ability(animation: String)
signal on_cooldown(button: Button, time: float, disable: bool)
signal ability_1_icons(icons: Array[Texture2D])
signal ability_2_icons(icons: Array[Texture2D])
signal ability_3_icons(icons: Array[Texture2D])

@export var target: CharacterBody3D = null
var abilities_data: HeroClassAbilitiesResource
var stat_ref: Dictionary = {}

var ability_1: Array[AbilityResource]
var ability_2: Array[AbilityResource]
var ultimate: Array[AbilityResource]

var duration: float = 0.0
var ability_min_value: int #heal or damage
var ability_max_value: int #heal or damage


func _ready() -> void:
	pass
	

func apply_ability_data(data: HeroClassAbilitiesResource) -> void:
	abilities_data = data
	ability_1 = abilities_data.ability_1
	ability_2 = abilities_data.ability_2
	ultimate = abilities_data.ultimate

func _calulate_ability_value() -> void:
	pass
