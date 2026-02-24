class_name EnemyHurtBoxComponent extends BoneAttachment3D

signal hit(area: Area3D)
signal not_hits

@onready var hurt_box: Area3D = %HurtBox
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var invincibility_timer: Timer = %InvincibilityTimer

@export var knockback_comp: KnockBackComponent
@export var invincibility_time: float = 0.25

var _can_get_hurt: bool = true

func hurt_box_monitoring_status(value: bool) -> void:
	hurt_box.set_deferred("monitorable", value)
	hurt_box.set_deferred("monitoring", value)

func _set_dead_enemy_layer() -> void:
	hurt_box.set_collision_layer_value(LayersConstants.LAYERS.ENEMY, false)
	hurt_box.set_collision_layer_value(LayersConstants.LAYERS.DEAD_ENEMIES, true)

func _set_revived_enemy_layer() -> void:
	hurt_box.set_collision_layer_value(LayersConstants.LAYERS.DEAD_ENEMIES, false)
	hurt_box.set_collision_layer_value(LayersConstants.LAYERS.ENEMY, true)

func _on_invincibility_timer_timeout() -> void:
	hurt_box.set_deferred("monitoring", true)
	_can_get_hurt = true

func _on_hurt_box_area_entered(area: Area3D) -> void:
	if not _can_get_hurt:
		return
	if area.is_in_group("player_weapon"):
		knockback_comp.hit_pos = area.global_position
		hit.emit(area)
		invincibility_timer.wait_time = invincibility_time
		invincibility_timer.start()
		_can_get_hurt = false
		hurt_box_monitoring_status(false)

func _on_enemy_health_component_dead() -> void:
	_can_get_hurt = false
	not_hits.emit()
	_set_dead_enemy_layer()
	hurt_box_monitoring_status(false)

func _on_hurt_box_area_exited(area: Area3D) -> void:
	if not _can_get_hurt:
		return
	if area.is_in_group("player_weapon"):
		if not invincibility_timer.is_stopped():
			invincibility_timer.stop()
			_can_get_hurt = true
			not_hits.emit()
			hurt_box_monitoring_status(true)
