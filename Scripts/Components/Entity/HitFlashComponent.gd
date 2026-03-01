class_name HitFlashComponent extends Node

@export var visuals: EnemyVisualComponent = null

var material_ref: Material = null

const HIT_FLASH = preload("uid://cb5y33pvgwgop")

func hit_flash_on() -> void:
	material_ref = visuals.entity_material
	
	for mesh in visuals.meshes:
		mesh.material_override = HIT_FLASH

func hit_flash_off() -> void:
	for mesh in visuals.meshes:
		mesh.material_override = material_ref


func _on_enemy_hurt_box_component_hit(_area: Area3D) -> void:
	hit_flash_on()
	await get_tree().create_timer(0.1).timeout
	hit_flash_off()
