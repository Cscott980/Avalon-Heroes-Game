class_name MainUI extends CanvasLayer

@onready var inventory_equipment: EquipmentandInventory = %InventoryEquipment
@onready var ability_bar: AbilityBar = %AbilityBar
@onready var display_stat_choice_component: DisplayStatChoiceComponent = %DisplayStatChoiceComponent

@export var stat_comp: StatComponent
@export var ability_comp: AbilityComponent
@export var health_comp: HealthComponent
@export var equip_visuals_comp: EquipmentVisualComponent
@export var resource_comp: ResourcePoolComponent

var invetory_open = false

func _ready() -> void:
	pass

func get_player_visual_data(defults_data: HeroClassVisualDefaultResource, equipment_resource: PlayerEquipmentResource) -> void:
	inventory_equipment.character_sheet_character.vs_defults = defults_data
	inventory_equipment.equipment = equipment_resource

func update_level_display(new_level: String) -> void:
	ability_bar.level_ui_dis.text = new_level
	inventory_equipment.level_display.text = new_level

func _on_player_input_component_charsheet() -> void:
	if not is_instance_valid(inventory_equipment):
		return
	if inventory_equipment.is_open:
		inventory_equipment.close()
	else:
		inventory_equipment.open()

func _on_progression_component_stat_choices(options: Array[Dictionary]) -> void:
	if not is_instance_valid(display_stat_choice_component):
		return
	display_stat_choice_component._on_progression_component_stat_choices(options)

func _on_progression_component_level(current_level: int) -> void:
	inventory_equipment.level_display.text = str(current_level)
	ability_bar.level_ui_dis.text = str(current_level)

func _on_progression_component_exp_collected(amount: int) -> void:
	ability_bar.experiance_bar.value = amount

func _on_resource_pool_component_current_resource_amount(amount: int) -> void:
	pass # Replace with function body.

func _on_resource_pool_component_resource_used(amount: int) -> void:
	pass # Replace with function body.

func _on_ability_component_on_cooldown(button: Button, time: float, disable: bool) -> void:
	pass # Replace with function body.

func _on_ability_component_ability_icons(icons: Array[Texture2D]) -> void:
	pass

func _on_inventory_equipment_current_equipment(slot_res: EquipmentSlotResource, item: ItemResource, sub_index: int, hand: StringName) -> void:
	if equip_visuals_comp.has_method("apply_equipment"):
		equip_visuals_comp.apply_equipment(slot_res, item, sub_index, hand)

func _on_quiz_display_component_questions_answered() -> void:
	pass # Replace with function body.

func _on_health_component_dead(_owner: Node) -> void:
	pass # Replace with function body.

func _on_player_input_component_charsheet_toggled() -> void:
	if inventory_equipment.is_open:
		invetory_open = false
		inventory_equipment.close()
	else:
		invetory_open = true
		inventory_equipment.open()

func _on_stat_component_current_stats(dic: Dictionary) -> void:
	inventory_equipment.update_stat_display(dic)

func _on_health_component_current_health(amount: int, max_player_health: int) -> void:
	inventory_equipment.apply_health_data(amount)
	ability_bar.player_health.value = amount
	ability_bar.player_health.max_value = float(max_player_health)

func _on_equipment_visual_component_player_head_for_sheat(mesh: Mesh, skin: Skin) -> void:
	inventory_equipment.character_sheet_character.head.mesh = mesh
	inventory_equipment.character_sheet_character.head.skin = skin
