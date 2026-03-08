class_name LevelUpVFX extends Node3D

@export var visuals: EquipmentVisualComponent

@onready var area_3d: Area3D = $Area3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

const LEVEL_SHADER: ShaderMaterial = preload("uid://bc34ol7xngftp")

var meshes: Array = []
var material: ShaderMaterial

func _ready() -> void:
	await get_tree().process_frame
	audio.stop()
	hide()
	meshes = visuals.visual_data
	material = LEVEL_SHADER
	

func level_vfx() -> void:
	show()
	if animation_player:
		animation_player.play("LevelUp")
		audio.play()
		apply_level_effect()

func apply_level_effect() -> void:
	for mesh in meshes:
		var item: MeshInstance3D = mesh
		item.material_overlay = material

func remove_level_effect() -> void:
	for mesh in meshes:
		var item: MeshInstance3D = mesh
		item.material_overlay = null

func _on_area_3d_area_entered(area: Area3D) -> void:
	var hit_comp: EnemyHurtBoxComponent = area.get_parent()
	hit_comp.knockback_comp.knockback()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"LevelUp":
		remove_level_effect()

func _on_progression_component_level(_current_level: int) -> void:
	level_vfx()
