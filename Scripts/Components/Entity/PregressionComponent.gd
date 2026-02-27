@icon("uid://d06el7ga76urj")
class_name ProgressionComponent extends Node

signal level(current_level:int)
signal stat_selected(stat: int, amount: int)
signal exp_collected(amount: int)
signal new_exp_max_value(value: int)
signal stat_choices(options: Array[Dictionary])

@export var player_ui: MainUI
@export var player_level: int = 1
@export var out_level_display: Label
@export var level_up_choice: int = 3
@export var max_level: int = 30
@export var starting_level: int = 1

var max_exp: int = 5
var xp_amount: int = 0
var pending_choices: Array = []
var has_pending_choices: bool = false
var chose_stat: Dictionary

func _ready() -> void:
	await  get_tree().process_frame
	player_level = starting_level
	level.emit(player_level)
	exp_collected.emit(xp_amount)
	out_level_display.text = str(player_level)

func level_up() -> void:
	if player_level <= max_level:
		var new_level = player_level + 1
		out_level_display.text = str(new_level)
		level.emit(new_level)
	"""
	Here I will add the logic to call the QuizManager to send a question prompt
	to the player to answer. 
	If correct the level up logic continues, 
	else the quiz manger just selects a new question from the quiz data base.
	"""
	var result:Array[Dictionary] = random_stat_generator(level_up_choice)
	stat_choices.emit(result)
	await stat_selected
	if not has_pending_choices:
		new_max_value()

func new_max_value() -> void:
	if player_level <= 10:
		max_exp += 10 #increases the max value by 10 every level till level 10
	if player_level <= 20 and player_level > 10:
		max_exp += 13 #increases the max value by 10 every level till level 20
	if player_level > 20 and player_level <= 30:
		max_exp += 16 #increases the max value by 10 every level till level 30
	new_exp_max_value.emit(max_exp)

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
	stat_choices.emit(choices)
	return choices

func _on_drop_pickup_component_exp_gem(amount: int) -> void:
	xp_amount += amount
	if xp_amount >= max_exp:
		level_up()

func _on_player_ui_stat_chosen(data: Dictionary) -> void:
	has_pending_choices = false
	stat_selected.emit(data)
