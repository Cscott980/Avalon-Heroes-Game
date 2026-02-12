class_name InventorySlot extends TextureRect

@export var slot_index: int = 0
@export var inventory: InventoryResource

var base: EquipmentandInventory

@onready var icon: TextureRect = $Icon

func get_item() -> ItemResource:
	if inventory == null:
		return null
	if slot_index < 0 or slot_index >= inventory.items.size():
		return null
	return inventory.items[slot_index]

func set_item(item: ItemResource) -> void:
	if inventory == null:
		return
	if slot_index >= inventory.items.size():
		inventory.items.resize(slot_index + 1)
	
	inventory.items[slot_index] = item
	_refresh()

func _ready() -> void:
	await  get_tree().process_frame
	base = get_tree().get_first_node_in_group("playersheet")
	_refresh()

func _refresh() -> void:
	if icon == null:
		push_error("%s icon is missing" % name)
	
	var item := get_item()
	if item == null:
		icon.texture = null
		return
	
	icon.texture = item.icon

func _get_drag_data(_at_position: Vector2) -> Variant:
	var item  := get_item()
	if icon == null or item == null or icon.texture == null:
		return null
		
	var preview = duplicate()
	var c = Control.new()
	c.add_child(preview)
	preview.position -= Vector2(25,25)
	set_drag_preview(c)
	base.play_pick_up_sound()
	icon.hide()
	return {
		"item": item,
		"from": "inventory",
		"from_index": slot_index,
		"inventory": inventory
	}

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("item")

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		if icon:
			icon.show()
		_refresh()

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if not (data is Dictionary):
		return
	
	var incoming: ItemResource = data.get("item")
	var current := get_item()
	
	set_item(incoming)
	
	if data.get("from") == "inventory":
		var from_i: int = data.get("from_index", -1)
		var from_inv: InventoryResource = data.get("inventory")
		
		if from_inv != null and from_i != -1:
			if from_inv == inventory and from_i == slot_index:
				pass
			else:
				if from_i >= from_inv.items.size():
					from_inv.items.resize(from_i + 1)
				from_inv.items[from_i] = current
	elif data.get("from") == "equipment":
		var from_eq = data.get("from_equipment")
		if is_instance_valid(from_eq):
			from_eq.clear_item()
	base.play_drop_sound()
	icon.show()
	_refresh()
