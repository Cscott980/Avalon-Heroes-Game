class_name HurtBoxComponent extends BoneAttachment3D

signal hit(area: Area3D)
signal not_hits

@onready var hurt_box: Area3D = %HurtBox
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var invincibility_timer: Timer = %InvincibilityTimer


var _can_get_hurt: bool = false

func _ready() -> void:
	_can_get_hurt = true

func _on_invincibility_timer_timeout() -> void:
	hurt_box.set_deferred("monitoring", true)
	_can_get_hurt = true

func _on_hurt_box_area_entered(area: Area3D) -> void:
	if not _can_get_hurt:
		return
	hit.emit(area)
	invincibility_timer.start()
	_can_get_hurt = false
	hurt_box.set_deferred("monitorable", false)
	hurt_box.set_deferred("monitoring", false)

func _on_enemy_health_component_dead() -> void:
	_can_get_hurt = false
	not_hits.emit()
	hurt_box.set_deferred("monitoring", false)
	hurt_box.set_deferred("monitorable", false)

func _on_hurt_box_area_exited(_area: Area3D) -> void:
	if not invincibility_timer.is_stopped():
		invincibility_timer.stop()
		_can_get_hurt = true
		not_hits.emit()
		hurt_box.set_deferred("monitorable", true)
		hurt_box.set_deferred("monitoring", true)


func _on_health_component_dead() -> void:
	_can_get_hurt = false
	not_hits.emit()
	hurt_box.set_deferred("monitoring", false)
	hurt_box.set_deferred("monitorable", false)
