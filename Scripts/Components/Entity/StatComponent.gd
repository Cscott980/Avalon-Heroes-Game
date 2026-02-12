@icon("uid://dgxgu38fy8hjs")
class_name StatComponent extends Node

signal current_stats(dic: Dictionary)

@export var user: CharacterBody3D

var stats: StatResource
var player_stats: Dictionary = {}

func _ready() -> void:
	await  get_tree().process_frame

	if not stats:
		return
		
	player_stats = {
		"strength": stats.strength,
		"intellect": stats.intellect,
		"dexterity": stats.dexterity,
		"vitality": stats.vitality,
		"wisdom": stats.wisdom,
	}
	current_stats.emit(player_stats)
	
func _on_progression_component_stat_selected(stat: int, amount: int) -> void:
	player_stats[stat] += amount
