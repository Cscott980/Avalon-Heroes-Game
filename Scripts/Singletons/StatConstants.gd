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

const STRING_TO_INT: Dictionary = {
	"strength": STATS.STRENGTH,
	"intellect": STATS.STRENGTH,
	"dexterity": STATS.STRENGTH,
	"vitality": STATS.STRENGTH,
	"wisdom": STATS.STRENGTH
	
}

const STAT_TO_FLAG := {
	STATS.STRENGTH: 1 << 0,
	STATS.INTELLECT: 1 << 1,
	STATS.DEXTERITY: 1 << 2,
	STATS.VITALITY: 1 << 3,
	STATS.WISDOM: 1 << 4,
}

const STRING_TO_FLAG: Dictionary = {
	"strength": 1 << 0,
	"intellect": 1 << 1,
	"dexterity": 1 << 2,
	"vitality": 1 << 3,
	"wisdom": 1 << 4,
}
#TODO: set up staticon UID
const ICON_REFERANCE: Dictionary = {
	STATS.STRENGTH: "something",
	STATS.INTELLECT: "something",
	STATS.DEXTERITY: "something",
	STATS.VITALITY: "something",
	STATS.WISDOM: "something"	
}


func load_flag_ref(stat: int) -> int:
	return STAT_TO_FLAG.get(stat, 0)

func load_stats_ref(stat: int) -> String:
	return STAT_REFERENCE.get(stat, "")

func load_stats_int(ref: String) -> int:
	return STRING_TO_INT.get(ref, 0)


# --- flag helpers ---
func has_stat(flags: int, stat: int) -> bool:
	var bit := load_flag_ref(stat)
	return (flags & bit) != 0

func add_stat(flags: int, stat: int) -> int:
	return flags | load_flag_ref(stat)

func remove_stat(flags: int, stat: int) -> int:
	return flags & ~load_flag_ref(stat)

# --- what you asked for: "get the stats that are true" ---
func get_true_stats(flags: int) -> Array[int]:
	var result: Array[int] = []
	for stat in STAT_TO_FLAG.keys():
		if has_stat(flags, stat):
			result.append(stat)
	return result

func get_true_stat_refs(flags: int) -> Array[String]:
	var result: Array[String] = []
	for stat in get_true_stats(flags):
		result.append(load_stats_ref(stat))
	return result
