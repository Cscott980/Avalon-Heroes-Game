class_name Drop extends RigidBody3D

@onready var drop: MeshInstance3D = %Drop
@onready var drop_sound: AudioStreamPlayer3D = %DropSound
@onready var aura: Sprite3D = %Aura

@export var items_data: Array[ItemDropResource]
@export var item_drop_weight: Array[int]

@export var pop_out_component: PopOutComponent

var selected_item: ItemDropResource = null
var drop_type: int
var drop_name: String
var item_value: float
var can_be_seen_by: Array[int]

func _ready() -> void:
	selected_item = calculate_weight_drop()
	
	if selected_item:
		apply_drop_data()
		pop_out_component.pop()
	else:
		queue_free()
		
func calculate_weight_drop() -> ItemDropResource:
	if items_data.is_empty():
		return null
		
	var total_weight: int = 0
	for weight in item_drop_weight:
		total_weight += weight
	
	var roll = randi_range(0, total_weight -1)
	var cursor = 0
	
	for i in range(item_drop_weight.size()):
		cursor += item_drop_weight[i]
		if roll < cursor:
			return items_data[i] #Winner
	
	return items_data[0]

func apply_drop_data() -> void:
	drop_type = selected_item.drop_type
	drop_name = selected_item.drop_name
	drop.mesh = selected_item.mesh
	item_value = selected_item.resource_amount
	can_be_seen_by = HeroClassConst.get_true_hero(selected_item.can_be_seen_by)

func _on_item_pull_component_picked_up(body: Player) -> void:
	if body.is_in_group("player"):
		var player: Player = body
		if player.hero_class.hero_class in can_be_seen_by:
			if player.has_node("DropPickupComponent"):
				var pickup_comp: DropPickUpComponent = player.get_node("DropPickupComponent")
				if pickup_comp.has_method("pickup"):
					pickup_comp.pickup(item_value, drop_type)
					if drop_sound.stream:
						drop_sound.play()
						aura.hide()
						drop.hide()
						await drop_sound.finished
						queue_free()
					else:
						queue_free()
	return
