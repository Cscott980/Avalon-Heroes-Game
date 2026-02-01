class_name ProgressionComponent extends Node

signal level(current_level:int)
signal stat_selected(stat: int, amount: int)
signal exp_collected(amount: int)

#@export var exp_collector: DropCollectorComponent
#var random_stat: RandomStatResource

var xp_amount: int = 0

func _ready() -> void:
	pass

func level_up(current_level: int) -> void:
	var new_level = current_level + 1
	#await random_stat_selector()
	emit_signal("level", new_level)

func random_stat_generator() -> Dictionary:
	var stat: Dictionary = {}
	var stat_generated: String = StatConst.STAT_REFERENCE[randi_range(1,5)]
	var random_value: float = randf_range(0.05, 0.20)
	stat[stat_generated] = random_value
	return stat

func random_stat_selector() -> Dictionary:
	var selected_stat: Dictionary = {}
	return {}
	
	
