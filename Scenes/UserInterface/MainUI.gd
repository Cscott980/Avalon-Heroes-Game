class_name MainUI extends CanvasLayer
@onready var inventory_equipment: CharacterSheetandInventory = $InventoryEquipment
@onready var ability_bar: AbilityBar = %AbilityBar

var ability_1_btn: TextureButton
var ability_2_btn: TextureButton
var ultimate_btn: TextureButton

var health_bar: ProgressBar
var exp_bar: ProgressBar
var resource_pool_bar: ProgressBar
var level_dis: String



func _ready() -> void:
	ability_1_btn = ability_bar.ability_1
	ability_2_btn = ability_bar.ability_2
	ultimate_btn = ability_bar.ability_3
	
	health_bar = ability_bar.player_health
	exp_bar = ability_bar.experiance_bar
	resource_pool_bar = ability_bar.resource_bar
	ability_bar.level_ui_dis.text = level_dis
	inventory_equipment.level_display.text = level_dis
	
func update_level_display(new_level: String) -> void:
	ability_bar.level_ui_dis.text = new_level
	inventory_equipment.level_display.text = new_level

func update_stat_display(stats: Dictionary, health: int) -> void:
	if not inventory_equipment:
		push_warning("MainUI: No Invetory / Stat Sheet found. Check UI scene.")
		return
	inventory_equipment.strength_val.text = stats.get(StatConst.load_stats_ref(StatConst.STATS.STRENGTH), 0)
	inventory_equipment.intellect_val.text = stats.get(StatConst.load_stats_ref(StatConst.STATS.INTELLECT), 0)
	inventory_equipment.dexterity_val.text = stats.get(StatConst.load_stats_ref(StatConst.STATS.DEXTERITY), 0)
	inventory_equipment.wisdom_val.text = stats.get(StatConst.load_stats_ref(StatConst.STATS.WISDOM), 0)
	inventory_equipment.vitality_val.text = stats.get(StatConst.load_stats_ref(StatConst.STATS.VITALITY), 0)
	
	inventory_equipment.health_val.text = str(int(health_bar.max_value))
