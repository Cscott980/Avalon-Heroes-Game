class_name InitWeapon extends Node3D

@export var WEAPON_TYPE: WeaponResource
@onready var slot_eqipted: Equipment
@onready var mesh: MeshInstance3D = $mesh
@onready var hit_box: Area3D = %HitBox
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var back_sheath: Node3D = %BackSheath
@onready var right_hip_sheath: Node3D = %RightHipSheath
@onready var left_hip_sheath: Node3D = %LeftHipSheath



var user: Player
var weapon_slot: BoneAttachment3D
var base_damage: int = 0
var weapon_damage: int
var weapon_attack_speed: float
var weapon_handedness: int
var weapon_defult_position: Transform3D
var weapon_slot_type: String
var user_stats: Dictionary
var weapon_stat_scale: float
var max_stack_effect: int
var dot_damage: int
var effect_type: String
var trail_visiblility: bool

func _ready() -> void:	
	user = get_tree().get_first_node_in_group("player")
	weapon_slot = get_parent()
	user_stats = user.player_stats

func clear_weapon() -> void:
	WEAPON_TYPE = null
	mesh.mesh = null
	if collision_shape_3d:
		collision_shape_3d.shape = null
	weapon_damage = 0
	base_damage = 0
	remove_from_group("main_hand")
	remove_from_group("off_hand")
	remove_from_group("one_hand_weapon")
	remove_from_group("two_handed_weapon")

func load_weapon(weapon_id: WeaponResource) -> void:
	WEAPON_TYPE = weapon_id
	if WEAPON_TYPE == null:
		return
	
	if weapon_slot.name == "OffHand":
		add_to_group("off_hand")
	else:
		add_to_group("main_hand")
	
	weapon_handedness = WEAPON_TYPE.handedness
	
	if weapon_handedness == 0:
		add_to_group("one_handed_weapon")
		print("hello")
	else:
		add_to_group("two_handed_weapon")
		print("hello")
		
	mesh.mesh = weapon_id.mesh
	collision_shape_3d.shape = weapon_id.collision_shape
	weapon_defult_position = mesh.transform
	if is_in_group("main_hand"):
		self.transform = Transform3D.IDENTITY
	
	base_damage = weapon_id.damage
	weapon_damage = base_damage
	weapon_attack_speed = weapon_id.weapon_speed
	weapon_stat_scale = weapon_id.scale_percentage #the percentage the weapon damage scales based on the player speciallized stat.
	
func recalculate_damage() -> void:
	if user == null or WEAPON_TYPE == null:
		return
	var total_stat: float = 0.0
	
	for stat_name in StatConstants.STAT_FLAG_MAP.keys():
		var flag = StatConstants.STAT_FLAG_MAP[stat_name]
		if (WEAPON_TYPE.scale_on_stat & flag) != 0:
			total_stat += user.player_stats.get(stat_name, 0)
	
	weapon_damage =  int(round(base_damage + total_stat * weapon_stat_scale))
	
func get_stat_effect_damage(target: Node3D) -> int:
	if target == null:
		return 0
	return WEAPON_TYPE.stat_effect.calculate_dot(target)

func _on_hit_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(weapon_damage)
