class_name EquipmentandInventory extends Control

signal current_equipment(slot_res: EquipmentSlotResource, item: ItemResource, sub_index: int, hand: StringName)


#------ Inventory and Equipment Brain -------
@onready var inventorybox: GridContainer = %Inventory/GridContainer
@onready var character_sheet_character: CharacterSheetDisplay = %CharacterSheetCharacter
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

#------ Stats Value ----- 
@onready var level_display: Label = %LevelDisplay

@onready var strength_val: Label = %StrengthVal
@onready var intellect_val: Label = %IntelectVal
@onready var dexterity_val: Label = %DexterityVal
@onready var vitality_val: Label = %VitalityVal
@onready var wisdom_val: Label = %WisdomVal
@onready var health_val: Label = %HealthVal

#-------------------------
@export var corner_size: int = 80
@export var inv : InventoryResource

var equipment: PlayerEquipmentResource
var pick_up_sound := preload("uid://c5lxkt43uv5h0")
var drop_sound := preload("uid://4r21t47kiawv")
var open_inventory_sound := preload("uid://72d01r063eta")

var inventory_slot: InventorySlot

var vs_data: Dictionary
var dragging: bool = false
var drag_offset := Vector2.ZERO
var player: Player = null
var is_open: bool = false
var equipment_equiped: Array = []


func _ready() -> void:
	await  get_tree().process_frame
	is_open = false
	visible = false
	_connect_equipment_slots()


func play_pick_up_sound() -> void:
	audio_stream_player.stream = pick_up_sound
	audio_stream_player.play()

func update_stat_display(stats: Dictionary, health: int) -> void:
	strength_val.text = stats.get(StatConst.load_stats_ref(StatConst.STATS.STRENGTH), 0)
	intellect_val.text = stats.get(StatConst.load_stats_ref(StatConst.STATS.INTELLECT), 0)
	dexterity_val.text = stats.get(StatConst.load_stats_ref(StatConst.STATS.DEXTERITY), 0)
	wisdom_val.text = stats.get(StatConst.load_stats_ref(StatConst.STATS.WISDOM), 0)
	vitality_val.text = stats.get(StatConst.load_stats_ref(StatConst.STATS.VITALITY), 0)
	
	health_val.text = str(health)

func play_drop_sound() -> void:
	audio_stream_player.stream = drop_sound
	audio_stream_player.play()

func _is_in_drag_corner(local_pos: Vector2) -> bool:
	var s := size
	
	var top_left = Rect2(Vector2.ZERO, Vector2(corner_size,corner_size))
	var top_right = Rect2(Vector2(s.x - corner_size, 0), Vector2(corner_size, corner_size))
	var bottom_left = Rect2(Vector2(0, s.y - corner_size), Vector2(corner_size, corner_size))
	var bottom_right = Rect2(Vector2(s.x - corner_size, s.y - corner_size),Vector2(corner_size, corner_size))
	
	return (
		top_left.has_point(local_pos)
		or top_right.has_point(local_pos)
		or bottom_left.has_point(local_pos)
		or bottom_right.has_point(local_pos)
	)

func close() -> void:
	self.visible = false
	audio_stream_player.stream = open_inventory_sound
	audio_stream_player.play()
	is_open = false

func open() -> void:
	self.visible = true
	audio_stream_player.stream = open_inventory_sound
	audio_stream_player.play()
	is_open = true

func _connect_equipment_slots() -> void:
	for node in get_tree().get_nodes_in_group("equipment_slot"):
		if node.has_signal("equipment_changed"):
			node.equipment_changed.connect(_on_equipment_changed)

func _on_equipment_changed(slot_res: EquipmentSlotResource, item: ItemResource, sub_index: int, hand: StringName) -> void:
	equipment.set_item(slot_res,item)
	character_sheet_character.apply_equipment(slot_res, item, sub_index, hand)
	current_equipment.emit(slot_res, item, sub_index, hand)
	for slot in get_tree().get_nodes_in_group("inventory_slot"):
		slot._refresh()
