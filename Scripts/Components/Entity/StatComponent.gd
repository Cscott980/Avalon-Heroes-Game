@icon("uid://dgxgu38fy8hjs")
class_name StatComponent extends Node

signal current_stats(dic: Dictionary)

@export var user: CharacterBody3D

var stats: StatResource
var primary_stat: int
var target_stats: Dictionary = {}


var mainhand_min_damage: int
var mainhand_max_damage: int
var mainhand_scale_per: float
var offhand_min_damage: int
var offhand_max_damage: int
var offhand_scale_per: float
var weapon_scale_stat_mainhand: Array[int] = []
var weapon_scale_stat_offhand: Array[int] = []


var armor: int = 5

func apply_stats(data: StatResource) -> void:
	stats = data
	target_stats = {
		StatConst.STATS.STRENGTH: stats.strength,
		StatConst.STATS.INTELLECT: stats.intellect,
		StatConst.STATS.DEXTERITY: stats.dexterity,
		StatConst.STATS.VITALITY: stats.vitality,
		StatConst.STATS.WISDOM: stats.wisdom,
	}
	primary_stat = stats.entity_main_stat
	armor = data.armor
	current_stats.emit(target_stats)

func apply_mainhand_weapon_stats(weapon_data: WeaponResource) -> void:
	mainhand_min_damage = weapon_data.min_damage
	mainhand_max_damage = weapon_data.max_damage
	weapon_scale_stat_mainhand = StatConst.get_true_stats(weapon_data.scale_on_stat)
	mainhand_scale_per = weapon_data.scale_percentage

func apply_offhand_weapon_stats(weapon_data: WeaponResource) -> void:
	offhand_min_damage = weapon_data.min_damage
	offhand_max_damage = weapon_data.max_damage
	weapon_scale_stat_offhand = StatConst.get_true_stats(weapon_data.scale_on_stat)
	offhand_scale_per = weapon_data.scale_percentage
	
	
func calculate_weapon_damage(base_damage: int, defense: int, is_mainhand: bool = true) -> int:
	var scale_stats: Array[int]
	var scale_percent: float
	
	if is_mainhand:
		scale_stats = weapon_scale_stat_mainhand
		scale_percent = mainhand_scale_per
	else:
		scale_stats = weapon_scale_stat_offhand
		scale_percent = offhand_scale_per
	
	var scaling_stat_value: int = 0
	
	# Find which stat this weapon scales from
	for stat in scale_stats:
		if stat in target_stats:
			scaling_stat_value = target_stats[stat]
			break
	
	var bonus_damage: float = scaling_stat_value * scale_percent
	
	var total_damage: float = base_damage + bonus_damage
	
	# Apply defense (simple flat reduction)
	total_damage = total_damage * (100.0 / (100.0 + defense))
	
	return max(1, round(total_damage))

func _on_progression_component_stat_selected(stat: int, amount: int) -> void:
	target_stats[stat] += amount
	if stat == primary_stat:
		pass


func _on_main_hand_weapon_weapon_data(data: WeaponResource, _group: String) -> void:
	if not data:
		return
	apply_mainhand_weapon_stats(data)


func _on_off_hand_weapon_weapon_data(data: WeaponResource, _group: String) -> void:
	if not data:
		return
	apply_offhand_weapon_stats(data)
