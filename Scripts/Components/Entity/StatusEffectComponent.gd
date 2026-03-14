class_name StatusEffectComponent extends Node

signal stuned
signal rooted
signal slowed(new_speed: float)
signal dot(damage: int)
signal status_ended
signal status_effect_data(art: Texture2D, desc: Dictionary, type: int)

@export var user: CharacterBody3D = null
@export var heal_vfx: PackedScene = null
@export var visuals: EquipmentVisualComponent = null

const HEAL_GLOW: ShaderMaterial = preload("uid://debihr3yipjr3")
const HIT_FLASH: StandardMaterial3D = preload("uid://cb5y33pvgwgop")

var active_status_effects: Array[StatusEffectsResource]
var icon: Texture2D
var description: Dictionary
var duration: float
var value_over_time: float #can be used for hots or dots
var max_stacks: int
var slow_value: float 

func _get_status_effect_data(data: StatusEffectsResource) -> void:
	duration = data.duration
	description = _get_stat_disc(data.display_name, data.description)
	value_over_time = _get_heal_or_dmg(data.effect_type, data.damage_per_second, data.heal_per_second)
	status_effect_data.emit(data.icon, description, data.effect_type)
	
func _get_stat_disc(status_name: String, info: String) -> Dictionary:
	var dict:Dictionary = {}
	if status_name == null or info == null:
		return {
			"name": "No Data",
			"description": "No Data"
		}
	dict["name"] = status_name
	dict["description"] = info
	return dict

func _get_heal_or_dmg(type: int, dmg_value: float, heal_value: float) -> float:
	var mod: float
	if type == -1 or type > StatusEffectsResource.EffectType.size():
		return 0
	if type== StatusEffectsResource.EffectType.DOT:
		mod = dmg_value
	elif type == StatusEffectsResource.EffectType.HOT:
		mod = heal_value
	return mod

func _on_drop_pickup_component_health_potion(_amount: float) -> void:
	if not heal_vfx == null:
		var vfx = heal_vfx.instantiate() as Node3D
		user.add_child(vfx)
		if vfx.has_node("HealSymbol"):
			var emitter = vfx.get_node("HealSymbol") as CPUParticles3D
			emitter.emitting = true
			heal_glow(true)
		await get_tree().create_timer(1.0).timeout
		user.remove_child(vfx)
		heal_glow(false)
		
		
func hit_flash(state: bool) -> void:
	if state:
		for i in visuals.visual_data:
			var mesh: MeshInstance3D = i
			mesh.material_override = HIT_FLASH
	else:
		for i in visuals.visual_data:
			var mesh: MeshInstance3D = i
			mesh.material_override = null
	
func heal_glow(state: bool) -> void:
	if state:
		for i in visuals.visual_data:
			var mesh: MeshInstance3D = i
			mesh.material_overlay = HEAL_GLOW
	else:
		for i in visuals.visual_data:
			var mesh: MeshInstance3D = i
			mesh.material_overlay = null


func _on_hurt_box_component_hit(area: Area3D) -> void:
	if not HIT_FLASH:
		return
	hit_flash(true)
	await get_tree().create_timer(1.0).timeout
	hit_flash(false)
