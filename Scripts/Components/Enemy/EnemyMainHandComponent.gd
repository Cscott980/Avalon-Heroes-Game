class_name EnemyMainHandComponent extends MeshInstance3D

signal enemy_hit(body: Player)
signal attack_animation(anim: String)
signal handedness(hand: int)

@onready var hit_box: Area3D = %HitBox
@onready var weapon_hit_box: CollisionShape3D = %WeaponHitBox


func  _ready() -> void:
	hit_box.monitoring = false

func apply_mainhand_weapon_visual_data(data: EnemyWeaponResource) -> void:
	if data == null or not is_instance_valid(data):
		push_warning("EnemyMainHandComponent: No Data Found")
		return
		
	self.mesh = data.main_hand
	weapon_hit_box.shape = data.main_hand_collision
	handedness.emit(data.main_hand_handedness)
	attack_animation.emit(data.attack_animation)

func hit_box_on() -> void:
	hit_box.monitoring = true

func  hit_box_off() -> void:
	hit_box.monitoring = false

func _on_hit_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		enemy_hit.emit(body)
	
