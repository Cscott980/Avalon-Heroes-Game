class_name WeaponConstants extends Node

enum WEAPONS {
	DAGGER,
	FIST_WEAPONS,
	SCYTHE,
	POLEARM,
	AXE,
	BATTLEAXE,
	SWORD,
	GREATSWORD,
	MACE,
	GREAT_HAMMER,
	BOW,
	CROSSBOW,
	GUN,
	THROWABLE,
	WAND,
	STAVE,
	RELIC
}

const WEAPON_STRING_REF: Dictionary = {
	WEAPONS.DAGGER: "dagger",
	WEAPONS.FIST_WEAPONS: "fist_weapon",
	WEAPONS.SCYTHE: "scythe",
	WEAPONS.POLEARM: "polearm",
	WEAPONS.AXE: "axe",
	WEAPONS.BATTLEAXE: "battleaxe",
	WEAPONS.SWORD: "sword",
	WEAPONS.GREATSWORD: "greatsword",
	WEAPONS.MACE: "mace",
	WEAPONS.GREAT_HAMMER: "great_hammer",
	WEAPONS.BOW: "bow",
	WEAPONS.CROSSBOW: "crossbow",
	WEAPONS.GUN: "gun",
	WEAPONS.THROWABLE: "throwable",
	WEAPONS.WAND: "wand",
	WEAPONS.STAVE: "staff",
	WEAPONS.RELIC: "relic"
}

const WEAPON_FLAG_REF: Dictionary = {
	WEAPONS.DAGGER: 1 << 0,
	WEAPONS.FIST_WEAPONS: 1 << 1,
	WEAPONS.SCYTHE: 1 << 2,
	WEAPONS.POLEARM: 1 << 3,
	WEAPONS.AXE: 1 << 4,
	WEAPONS.BATTLEAXE: 1 << 5,
	WEAPONS.SWORD: 1 << 6,
	WEAPONS.GREATSWORD: 1 << 7,
	WEAPONS.MACE: 1 << 8,
	WEAPONS.GREAT_HAMMER: 1 << 9,
	WEAPONS.BOW: 1 << 10,
	WEAPONS.CROSSBOW: 1 << 11,
	WEAPONS.GUN: 1 << 12,
	WEAPONS.THROWABLE: 1 << 13,
	WEAPONS.WAND: 1 << 14,
	WEAPONS.STAVE: 1 << 15,
	WEAPONS.RELIC: 1 << 16
}

func load_flag_ref(stat: int) -> int:
	return WEAPON_FLAG_REF.get(stat, 0)

func load_string_ref(weapon: int) -> String:
	return WEAPON_STRING_REF.get(weapon, "")

func has_weapon(flags: int, weapon: int) -> bool:
	var bit := load_flag_ref(weapon)
	return (flags & bit) != 0

func get_true_stats(flags: int) -> Array[int]:
	var result: Array[int] = []
	for stat in WEAPON_FLAG_REF.keys():
		if has_weapon(flags, stat):
			result.append(stat)
	return result
