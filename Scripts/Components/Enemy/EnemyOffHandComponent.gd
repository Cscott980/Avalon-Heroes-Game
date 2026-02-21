class_name EnemyOffHandComponent extends MeshInstance3D

signal enemy_hit(body: Player)
signal attack_animation(anim: String)
signal handedness(hand: int)

@onready var hit_box: Area3D = %OffHandHitBox
@onready var item_hit_box: CollisionShape3D = %ItemHitBox



func  _ready() -> void:
	hit_box.monitoring = false

func apply_offhand_weapon_visual_data(data: EnemyWeaponResource) -> void:
	if data == null or not is_instance_valid(data):
		push_warning("EnemyMainHandComponent: No Data Found")
		return
		
	self.mesh = data.off_hand if data != null else null
	item_hit_box.shape = data.off_hand_collision if data != null else null

func off_hit_box_on() -> void:
	hit_box.monitoring = true

func  off_hit_box_off() -> void:
	hit_box.monitoring = false

func _on_off_hand_hit_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		enemy_hit.emit(body)
