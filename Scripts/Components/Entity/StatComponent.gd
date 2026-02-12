@icon("uid://dgxgu38fy8hjs")
class_name StatComponent extends Node

signal current_stats(dic: Dictionary)

@export var user: CharacterBody3D

var stats: StatResource
var primary_stat: int
var player_stats: Dictionary = {}

func _ready() -> void:
	pass

func apply_stats(data: StatResource) -> void:
	stats = data
	player_stats = {
		StatConst.STATS.STRENGTH: stats.strength,
		StatConst.STATS.INTELLECT: stats.intellect,
		StatConst.STATS.DEXTERITY: stats.dexterity,
		StatConst.STATS.VITALITY: stats.vitality,
		StatConst.STATS.WISDOM: stats.wisdom,
	}
	primary_stat = stats.entity_main_stat

func _on_progression_component_stat_selected(stat: int, amount: int) -> void:
	player_stats[stat] += amount
