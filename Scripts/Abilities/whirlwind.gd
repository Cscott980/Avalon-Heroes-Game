class_name Whirlwind extends Node3D

signal request_dmg

@onready var hit_box: Area3D = %HitBox
@onready var dps: Timer = %DPS

@export var time: float = 0.5
var damage: int

var user: Player = null
var ability_comp: AbilityComponent = null

func _ready() -> void:
	user = get_parent()
	if user.has_node("AbilityComponent"):
		ability_comp = user.get_node("AbilityComponent")
		if not ability_comp.ability_package.is_connected(_on_ability_component_ability_package):
			ability_comp.ability_package.connect(_on_ability_component_ability_package)

func _on_hit_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		request_dmg.emit()
		var hurt_comp: EnemyHurtBoxComponent = body.get_parent()
		hurt_comp.damage_recived.emit(damage)
		dps.start(time)

func _on_ability_component_ability_package(dmg: int, heal: int, status_effect: int) -> void:
	damage = dmg
