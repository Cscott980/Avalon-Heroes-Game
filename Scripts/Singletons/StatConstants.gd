class_name StatConstants extends Node

enum STATS {
	STRENGTH,
	INTELLECT,
	DEXTERITY,
	VITALITY,
	WISDOM
}

const STAT_REFERENCE: Dictionary = {
	STATS.STRENGTH: "strength",
	STATS.INTELLECT: "intellect",
	STATS.DEXTERITY: "dexterity",
	STATS.VITALITY: "vitality",
	STATS.WISDOM: "wisdom" 
}

const STAT_FLAG_MAP: Dictionary = {
	"strength": 1 << 0,
	"intellect": 1 << 1,
	"dexterity": 1 << 2,
	"wisdom": 1 << 3,
	"vitality": 1 << 4,
}

func load_stats_ref(stat: int) -> String:
	return STAT_REFERENCE.get(stat, "")
