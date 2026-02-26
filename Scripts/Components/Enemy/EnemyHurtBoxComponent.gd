class_name EnemyHurtBoxComponent extends Node3D

signal hit(area: Area3D)
signal damage_recived(damage: int)

@onready var hurt_box: Area3D = %HurtBox
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var invincibility_timer: Timer = %InvincibilityTimer

@export var user: Enemy
@export var stat_comp: StatComponent
@export var knockback_comp: KnockBackComponent
@export var invincibility_time: float = 0.25

var armor: int
var _can_get_hurt: bool = true

func _ready() -> void:
	armor = stat_comp.armor

func _on_invincibility_timer_timeout() -> void:
	_can_get_hurt = true

func _on_hurt_box_area_entered(area: Area3D) -> void:
	if not _can_get_hurt:
		return
	if area.is_in_group("player_weapon"):
		hit.emit(area)
		user.state_machine.change_state("HurtState")
		knockback_comp.knockback()
		invincibility_timer.wait_time = invincibility_time
		invincibility_timer.start()
		_can_get_hurt = false

func _on_enemy_health_component_dead() -> void:
	hurt_box.set_deferred("monitorable", false)
	hurt_box.set_deferred("monitoring", false)
	_can_get_hurt = false
