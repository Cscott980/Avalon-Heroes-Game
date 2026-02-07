@icon("uid://d1kvwucvgso6m")
class_name AbilityComponent extends Node

signal cast_ability(animation: String, duration: float)
signal on_cooldown(button: Button, time: float, disable: bool)
signal ability_effect(vfx: AnimationPlayer)
signal ability_icons(icons: Array[Texture2D])

@export var target: CharacterBody3D = null
var abilities: HeroClassAbilitiesResource

var ability_1: Array[AbilityResource]
var ability_2: Array[AbilityResource]
var ability_3: Array[AbilityResource]

func _ready() -> void:
	pass
