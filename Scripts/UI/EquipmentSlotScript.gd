class_name Equipment extends TextureRect

signal equipment_changed(slot_res: EquipmentSlotResource, item: ItemResource, sub_index: int, hand: StringName)


@onready var icon: TextureRect = $Icon
@onready var tool_tip: Label = null

@export var armor: ArmorResource
@export var weapon: WeaponResource
@export var SLOT_TYPE: EquipmentSlotResource

@export_enum("main", "off") var hand_role: String = "main"

@export var main_hand_slot_ui: Equipment
@export var off_hand_slot_ui: Equipment

@export var accessory_index: int = -1

var base: CharacterSheetandInventory
var item: ItemResource = null

func _ready() -> void:
	base = get_tree().get_first_node_in_group("playersheet")
	_refresh()

func _refresh() -> void:
	if item != null:
		icon.texture = item.icon
	else:
		icon.texture = null

func clear_item() -> void:
	item = null
	_refresh()
	equipment_changed.emit(SLOT_TYPE, null, accessory_index, StringName(hand_role))

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT and item != null:
		_add_to_inventory(base.inv, item)
		base.play_drop_sound()
		clear_item()

func set_item(new_item: ItemResource) -> void:
	item = new_item
	_refresh()
	equipment_changed.emit(SLOT_TYPE, item, accessory_index, StringName(hand_role))

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		if icon:
			icon.show()

func _get_drag_data(_at_position: Vector2) -> Variant:
	if item == null or icon == null or icon.texture == null:
		return null
	
	var preview_icon := TextureRect.new()
	preview_icon.texture = icon.texture
	preview_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_icon.custom_minimum_size = icon.size
	
	var c := Control.new()
	c.add_child(preview_icon)
	preview_icon.position = -preview_icon.custom_minimum_size * 0.5

	set_drag_preview(c)
	icon.hide()
	base.play_pick_up_sound()
	return {
		"item": item,
		"from": "equipment",
		"from_equipment": self
	}

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if not (data is Dictionary):
		return false
	var incoming: ItemResource = data.get("item")
	if incoming == null:
		return false
	
	match SLOT_TYPE.equipment_slot_type:
		EquipmentSlotResource.SlotType.Weapon:
			if not (incoming is WeaponResource):
				return false
			var w := incoming as WeaponResource
			
			if hand_role == "off" and w.handedness == WeaponResource.HANDEDNESS.TWO_HANDED:
				return false
				
			return true
		EquipmentSlotResource.SlotType.Helm, EquipmentSlotResource.SlotType.Armor, EquipmentSlotResource.SlotType.Back:
			if not (incoming is ArmorResource):
				return false
			var a:= incoming as ArmorResource
			return a.armor_slot_type != null and a.armor_slot_type.equipment_slot_type == SLOT_TYPE.equipment_slot_type
			
		EquipmentSlotResource.SlotType.Accessory:
			if not (incoming is ArmorResource):
				return false
			var a := incoming as ArmorResource
			return a.armor_slot_type != null and a.armor_slot_type.equipment_slot_type == SLOT_TYPE.equipment_slot_type
		
	return false

func _add_to_inventory(inv: InventoryResource, it: ItemResource) -> void:
	if inv == null or it == null:
		return 
	for i in range(inv.items.size()):
		if inv.items[i] == null:
			inv.items[i] = it
			return
	if SLOT_TYPE.equipment_slot_type == EquipmentSlotResource.SlotType.Weapon:
		if hand_role == "off":
			off_hand_slot_ui.clear_item()
		else:
			main_hand_slot_ui.clear_item()
	_notification(NOTIFICATION_DRAG_END)

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if not (data is Dictionary):
		return
	var incoming: ItemResource = data.get("item")
	if incoming == null:
		return
	if not _can_drop_data(_at_position, data):
		return
	
	var previous := item
	set_item(incoming)
	
	if SLOT_TYPE.equipment_slot_type == EquipmentSlotResource.SlotType.Weapon:
		var w := incoming as WeaponResource
		if w != null and hand_role == "off":
			if main_hand_slot_ui != null:
				var mh_item := main_hand_slot_ui.item as WeaponResource
				if mh_item != null and mh_item.handedness == WeaponResource.HANDEDNESS.TWO_HANDED:
					_add_to_inventory(base.inv, mh_item)
					main_hand_slot_ui.clear_item()
		elif w != null and hand_role == "main" and w.handedness != WeaponResource.HANDEDNESS.ONE_HANDED:
			if off_hand_slot_ui != null:
				var oh_item := off_hand_slot_ui.item as WeaponResource
				if oh_item != null and oh_item.handedness == WeaponResource.HANDEDNESS.ONE_HANDED:
					_add_to_inventory(base.inv, oh_item)
					off_hand_slot_ui.clear_item()

	if data.get("from") == "inventory":
		var inv_ui := get_tree().get_first_node_in_group("playersheet") as CharacterSheetandInventory
		if inv_ui != null and inv_ui.inv != null:
			var from_i: int = data.get("from_index", -1)
			if from_i != -1:
				inv_ui.inv.items[from_i] = previous
				for s in get_tree().get_nodes_in_group("inventory_slot"):
					(s as InventorySlot)._refresh()
	elif data.get("from") == "equipment":
		var from_eq = data.get("from_equipment")
		if is_instance_valid(from_eq) and from_eq != self:
			from_eq.item = previous
			from_eq._refresh()
			from_eq.equipment_changed.emit(from_eq.SLOT_TYPE, from_eq.item, from_eq.accessory_index, StringName(from_eq.hand_role))
	base.play_drop_sound()
	icon.show()
	_refresh()
