class_name HurtBoxComponent extends BoneAttachment3D

@onready var hurt_box: Area3D = %HurtBox
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var invincibility_timer: Timer = %InvincibilityTimer


var _can_get_hurt: bool = false

func _ready() -> void:
	_can_get_hurt = true

func _on_invincibility_timer_timeout() -> void:
	hurt_box.monitoring = true
	_can_get_hurt = true

func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area.is_in_group("player_weapon") or area.is_in_group("player_projectile"):
		invincibility_timer.start()
		_can_get_hurt = false
		hurt_box.monitoring = false

func _on_enemy_health_component_dead() -> void:
	_can_get_hurt = false
	hurt_box.monitoring = false
