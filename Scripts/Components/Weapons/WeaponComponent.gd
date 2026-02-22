class_name WeaponComponent extends Node3D

signal weapon_hit(target: Node3D)
signal weapon_data(data: WeaponResource, group: String)
signal no_weapon_equiped(status: bool)

@export var WEAPON_TYPE: WeaponResource

@onready var mesh: MeshInstance3D = $mesh
@onready var hit_box: Area3D = %HitBox
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var back_sheath: Node3D = %BackSheath
@onready var right_hip_sheath: Node3D = %RightHipSheath
@onready var left_hip_sheath: Node3D = %LeftHipSheath

@export var weapon_slot: BoneAttachment3D
var min_damage: int 
var max_damage: int
var weapon_attack_speed: float
var weapon_handedness: int
var weapon_defult_position: Transform3D
var attack_data: Array[AttackDataResource]
var attack_type: int

func _ready() -> void:
	if WEAPON_TYPE == null:
		return 
	weapon_slot = get_parent()
	
func clear_weapon() -> void:
	WEAPON_TYPE = null
	mesh.mesh = null
	if collision_shape_3d:
		collision_shape_3d.shape = null
	remove_from_group("main_hand")
	remove_from_group("off_hand")
	remove_from_group("one_hand_weapon")
	remove_from_group("two_handed_weapon")
	no_weapon_equiped.emit(true)
	
func load_weapon(weapon_id: WeaponResource) -> void:
	# Determine weapon group
	var group_name: String = ""
	if weapon_slot and weapon_slot.name == "OffHand":
		add_to_group("off_hand")
		group_name = "OffHand"
	else:
		add_to_group("main_hand")
		group_name = "MainHand"
	
	weapon_handedness = weapon_id.handedness
	
	if weapon_handedness == 0:
		add_to_group("one_handed_weapon")
	else:
		add_to_group("two_handed_weapon")
	
	min_damage = weapon_id.min_damage
	max_damage = weapon_id.max_damage
	attack_type = weapon_id.attack_type
	attack_data = weapon_id.attack_combo
	mesh.mesh = weapon_id.mesh
	collision_shape_3d.shape = weapon_id.collision_shape
	weapon_defult_position = mesh.transform
	
	if is_in_group("main_hand"):
		self.transform = Transform3D.IDENTITY
	
	weapon_attack_speed = weapon_id.weapon_speed
	
	# FIXED: Properly emit with both arguments
	weapon_data.emit(weapon_id, group_name)
	no_weapon_equiped.emit(false)
	
func weapon_hit_box_on() -> void:
	if hit_box:
		hit_box.monitoring = true
		hit_box.monitorable = true

func weapon_hit_box_off() -> void:
	if hit_box:
		hit_box.monitoring = false
		hit_box.monitorable = false

func _on_hit_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		weapon_hit.emit(body)
