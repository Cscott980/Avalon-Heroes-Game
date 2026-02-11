@icon("uid://d06el7ga76urj")
class_name ProgressionComponent extends Node

signal level(current_level:int)
signal stat_selected(stat: int, amount: int)
signal exp_collected(amount: int)
signal new_exp_max_value(value: int)
signal stat_choices(options: Array[Dictionary])

@export var player_ui: PlayerUI
@export var out_level_display: Label
#@export var exp_collector: DropCollectorComponent
@export var level_up_choice: int = 3

var xp_amount: int = 0
var pending_choices: Array = []
var has_pending_choices: bool = false

func _ready() -> void:
	pass

func level_up(current_level: int) -> void:
	var new_level = current_level + 1
	out_level_display.text = str(new_level)
	var result: Dictionary = {}
	if not has_pending_choices:
		level.emit(new_level)

func new_max_value() -> void:
	pass

func random_stat_generator(count: int) -> Array[Dictionary]:
	var choices: Array[Dictionary] = []
	var avilable_stats: Array = StatConst.STAT_REFERENCE.values().duplicate()
	avilable_stats.shuffle()
	
	for i in min(count, avilable_stats.size()):
		var stat_name: String = avilable_stats[i]
		var value: float = randf_range(0.05, 0.20)
		
		choices.append({
			"stat": stat_name,
			"value": value
		})
	emit_signal("stat_choices",choices)
	return choices
