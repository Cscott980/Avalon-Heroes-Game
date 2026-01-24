class_name ClassDataBase extends Node

enum HERO_CLASS { WARRIOR, MAGE, PALADIN, ROGUE, RANGER, DRUID, ENGINEER }

var classdb: Dictionary = {}

const CLASS_TO_STRING: Dictionary = {
	HERO_CLASS.WARRIOR: "warrior",
	HERO_CLASS.MAGE : "mage",
	HERO_CLASS.PALADIN: "paladin",
	HERO_CLASS.ROGUE: "rogue",
	HERO_CLASS.RANGER: "ranger",
	HERO_CLASS.DRUID: "druid",
	HERO_CLASS.ENGINEER: "engineer"
}

func _ready() -> void:
	classdb = GameData.classes.get("classes", {})

func get_armor_defults(hero: String) -> Dictionary:
	var class_chosen = classdb.get(hero, {})
	var hero_armor = class_chosen.get("defult_armor", {})
	return hero_armor

func load_class_id(class_picked: int) -> String:
	return CLASS_TO_STRING.get(class_picked, "")
