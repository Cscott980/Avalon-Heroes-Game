class_name EnemyStatsCompoment extends Node

signal current_stats(dic: Dictionary, a: int, ms: int)

var base_stats: StatResource
var base_stats_dic: Dictionary = {}
var base_armor: int
var enemy_main_stat: int = -1
var e_stats: Dictionary = {}
var armor: int

func _ready() -> void:
	pass
	
func apply_enemy_stats(stats: StatResource) -> void:
	if stats == null:
		return
	base_stats = stats
	enemy_main_stat = stats.entity_main_stat
	base_armor = stats.armor
	armor = stats.armor
	e_stats = {
		StatConst.STATS.STRENGTH:  base_stats.strength,
		StatConst.STATS.INTELLECT:  base_stats.intellect,
		StatConst.STATS.DEXTERITY:  base_stats.dexterity,
		StatConst.STATS.VITALITY:  base_stats.vitality,
		StatConst.STATS.WISDOM:  base_stats.wisdom
	}
	base_stats_dic = e_stats.duplicate(true) #make a copy of current base stats once init
	current_stats.emit(e_stats, armor, enemy_main_stat)

func level_up_stats(level: int) -> void:
	for stat in e_stats:
		if stat == enemy_main_stat:
			e_stats[stat] = base_stats_dic[stat] + ((level - 1)*2)
		else:
			e_stats[stat] = base_stats_dic[stat] + int(level/2.0)
	armor = int(base_armor + int(level/3.0))
		

		
func _on_enemy_level_component_level(current_level: int) -> void:
	level_up_stats(current_level)
	current_stats.emit(e_stats, armor, enemy_main_stat)
