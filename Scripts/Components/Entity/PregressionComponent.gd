@icon("uid://d06el7ga76urj")
class_name ProgressionComponent extends Node

signal leveling(status:bool)
signal level(current_level:int)
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
	var player: Player = get_parent()
	player.remove_from_group("player")
	leveling.emit(true)
	player.level_phase.emit()
	await player.clear

	var result: Array[Dictionary] = random_stat_generator(level_up_choice)
	stat_choices.emit(result)
	await player_ui.stat_chosen
	leveling.emit(false)
	player.add_to_group("player")

	if player_level < max_level:
		player_level += 1
		out_level_display.text = str(player_level)
		level.emit(player_level)
	else:
		player_level = max_level

	if not has_pending_choices:
		new_max_value()

func new_max_value() -> void:
	if player_level < 10:
		max_exp += 10 #increases the max value by 10 every level till level 10
	if player_level < 20 and player_level >= 10:
		max_exp += 13 #increases the max value by 10 every level till level 20
	if player_level >= 20 and player_level < 30:
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
	return choices

func _on_drop_pickup_component_exp_gem(amount: int) -> void:
	xp_amount += amount
	exp_collected.emit(xp_amount)
	if xp_amount >= max_exp:
		xp_amount = 0
		exp_collected.emit(xp_amount)
		level_up()

func _on_player_ui_stat_chosen(_data: Dictionary) -> void:
	has_pending_choices = false
	
