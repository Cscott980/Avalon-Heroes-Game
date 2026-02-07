class_name HeroClassConstants extends Node

enum HERO_CLASS { WARRIOR, MAGE, PALADIN, ROGUE, RANGER, DRUID, ENGINEER }

var classdb: Dictionary = {}
const HERO_CLASS_DISPLAY_NAME = {
	HERO_CLASS.WARRIOR: "Warrior",
	HERO_CLASS.MAGE : "Mage",
	HERO_CLASS.PALADIN: "Paladin",
	HERO_CLASS.ROGUE: "Rogue",
	HERO_CLASS.RANGER: "Ranger",
	HERO_CLASS.DRUID: "Druid",
	HERO_CLASS.ENGINEER: "Engineer"
}

const HERO_CLASS_TO_STRING: Dictionary = {
	HERO_CLASS.WARRIOR: "warrior",
	HERO_CLASS.MAGE : "mage",
	HERO_CLASS.PALADIN: "paladin",
	HERO_CLASS.ROGUE: "rogue",
	HERO_CLASS.RANGER: "ranger",
	HERO_CLASS.DRUID: "druid",
	HERO_CLASS.ENGINEER: "engineer"
}

const HERO_CLASS_FLAG_MAP: Dictionary = {
	"warrior": 1 << 0,
	"mage": 1 << 1,
	"paladin": 1 << 2,
	"ranger": 1 << 3,
	"rogue": 1 << 4,
	"druid": 1 << 5,
	"engineer": 1 << 6,
}

func load_class_to_string(class_picked: int) -> String:
	return HERO_CLASS_TO_STRING.get(class_picked, "")
