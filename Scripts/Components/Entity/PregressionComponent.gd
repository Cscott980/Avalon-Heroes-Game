class_name ProgressionComponent extends Node

signal level(current_level:int)
signal stat_selected(stat: int, amount: int)
signal exp_collected(amount: int)
signal stat_choices(options: Array[Dictionary])

#@export var exp_collector: DropCollectorComponent
#var random_stat: RandomStatResource

var xp_amount: int = 0
var pending_choices: Array = []
var has_pending_choices: bool = false
func _ready() -> void:
	pass

func level_up(current_level: int) -> void:
	var new_level = current_level + 1
	var result: Dictionary = random_stat_selector(3)
	if not has_pending_choices:
		emit_signal("stat_selected", StatConst.load_stats_int(result.get("stat", "")), result.get("value", 0))
		emit_signal("level", new_level)

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
	
	
func random_stat_selector(index: int) -> void:
	if not has_pending_choices:
		return 
	#if index
	
	return 
	
	
