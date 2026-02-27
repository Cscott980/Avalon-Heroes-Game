class_name EXPGem extends Node3D

@onready var gem: MeshInstance3D = %Gem
@onready var gem_sound: AudioStreamPlayer3D = %GemSound

@export var drop_data: ItemDropResource
@export var resource_value: int

func _on_item_pull_component_picked_up(body: Player) -> void:
	if body.is_in_group("player"):
		if body.has_node("ProgressionComponent"):
			var prog_comp: ProgressionComponent = body.get_node("ProgressionComponent")
			if prog_comp.has_method("pickup_exp"):
				await gem_sound.finished
				self.queue_free()
