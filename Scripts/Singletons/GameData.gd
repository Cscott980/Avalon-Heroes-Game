class_name Game_Data extends Node

var quiz_setting: Dictionary = {}
var quests: Dictionary = {}
var shop_inventory: Dictionary = {}
var classes: Dictionary = {}
var enemies: Dictionary = {}
var bosses: Dictionary = {}
var npc: Dictionary = {}
var abilities: Dictionary = {}
var weapons: Dictionary = {}
var armor: Dictionary = {}
var mounts: Dictionary = {}
var items: Dictionary = {}
var class_visual_defults: Dictionary = {}

func _ready() -> void:
	load_all()


func load_all() -> void:
	classes = _load_json("res://Scripts/Data/classes.json")
	items = _load_json("res://Scripts/Data/items.json")
	weapons = _load_json("res://Scripts/Data/weapons.json")
	abilities = _load_json("res://Scripts/Data/abilities.json")
	enemies = _load_json("res://Scripts/Data/enemies.json")
	class_visual_defults = _load_json("res://Scripts/Data/class_mesh_defults.json")

	
func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path,FileAccess.READ)
	var text := file.get_as_text()
	var result = JSON.parse_string(text)
	return result
