class_name EnemyVisualComponent extends Node

@export var arm_left: MeshInstance3D
@export var arm_right: MeshInstance3D
@export var body: MeshInstance3D
@export var cloak: MeshInstance3D
@export var eyes: MeshInstance3D
@export var head: MeshInstance3D
@export var jaw: MeshInstance3D
@export var leg_left: MeshInstance3D
@export var leg_right: MeshInstance3D
@export var accessory_1: MeshInstance3D
@export var accessory_2: MeshInstance3D
@export var accessory_3: MeshInstance3D

@export var weapon_mesh: MeshInstance3D
@export var weapon_shield_relic: MeshInstance3D

var entity_skin: Skin
var meshes: Array[MeshInstance3D] = []

var highlight: Material = preload("uid://cfrxegokeyufx")

func _ready() -> void:
	meshes = [
		arm_left,
		arm_right,
		body,
		cloak,
		eyes,
		head,
		jaw,
		leg_left,
		leg_right,
		accessory_1,
		accessory_2,
		accessory_3,
		weapon_mesh,
		weapon_shield_relic
	]

func apply_visuals(data: EnemyVisualsResource) -> void:
	if data == null or not is_instance_valid(data):
		return
	entity_skin = data.model_skin
	
	arm_left.mesh = data.left_arm if data != null else null
	arm_right.mesh = data.right_arm if data != null else null
	body.mesh = data.body if data != null else null
	cloak.mesh = data.cloak if data != null else null
	eyes.mesh = data.eyes if data != null else null
	head.mesh = data.head if data != null else null
	jaw.mesh = data.jaw if data != null else null
	leg_left.mesh = data.left_leg if data != null else null
	leg_right.mesh = data.right_leg if data != null else null
	accessory_1.mesh = data.accessory1 if data != null else null
	accessory_2.mesh = data.accessory2 if data != null else null
	accessory_3.mesh = data.accessory3 if data != null else null
	
	arm_left.skin = entity_skin if arm_left.mesh != null else null
	arm_right.skin = entity_skin if arm_right.mesh != null else null
	body.skin = entity_skin if body.mesh != null else null
	cloak.skin = entity_skin if cloak.mesh != null else null
	eyes.skin = entity_skin if eyes.mesh != null else null
	head.skin = entity_skin if head.mesh != null else null
	jaw.skin = entity_skin if jaw.mesh != null else null
	leg_left.skin = entity_skin if leg_left.mesh != null else null
	leg_right.skin = entity_skin if leg_right.mesh != null else null
	accessory_1.skin = entity_skin if accessory_1.mesh != null else null
	accessory_2.skin = entity_skin if accessory_2.mesh != null else null
	accessory_3.skin = entity_skin if accessory_3.mesh != null else null

func highlighter_on() -> void:
	for mesh in meshes:
		mesh.material_overlay = highlight

func highlighter_off() -> void:
	for mesh in meshes:
		mesh.material_overlay = null
