class_name WeaponComponent extends Node3D

signal weapon_hit(target: Node3D)
signal weapon_data(data: WeaponResource)
@export var WEAPON_TYPE: WeaponResource
@onready var mesh: MeshInstance3D = $mesh
@onready var hit_box: Area3D = %HitBox
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var back_sheath: Node3D = %BackSheath
@onready var right_hip_sheath: Node3D = %RightHipSheath
@onready var left_hip_sheath: Node3D = %LeftHipSheath

var weapon_slot: BoneAttachment3D
var weapon_attack_speed: float
var weapon_handedness: int
var weapon_defult_position: Transform3D

func _ready() -> void:	
	weapon_slot = get_parent()
	weapon_data.emit(WEAPON_TYPE)

func clear_weapon() -> void:
	WEAPON_TYPE = null
	mesh.mesh = null
	if collision_shape_3d:
		collision_shape_3d.shape = null
	remove_from_group("main_hand")
	remove_from_group("off_hand")
	remove_from_group("one_hand_weapon")
	remove_from_group("two_handed_weapon")

func load_weapon(weapon_id: WeaponResource) -> void:
	if WEAPON_TYPE == null:
		return
	
	if weapon_slot.name == "OffHand":
		add_to_group("off_hand")
	else:
		add_to_group("main_hand")
	
	weapon_handedness = WEAPON_TYPE.handedness
	
	if weapon_handedness == 0:
		add_to_group("one_handed_weapon")
	else:
		add_to_group("two_handed_weapon")
		
	mesh.mesh = weapon_id.mesh
	collision_shape_3d.shape = weapon_id.collision_shape
	weapon_defult_position = mesh.transform
	if is_in_group("main_hand"):
		self.transform = Transform3D.IDENTITY
	
	weapon_attack_speed = weapon_id.weapon_speed
func weapon_hit_box_on() -> void:
	if hit_box:
		hit_box.monitoring = true

func weapon_hit_box_off() -> void:
	if hit_box:
		hit_box.monitoring = false

func _on_hit_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		weapon_hit.emit(body)
