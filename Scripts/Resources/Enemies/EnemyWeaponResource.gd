class_name EnemyWeaponResource extends Resource

enum HANDEDNESS {
	ONE_HANDED,
	TWO_HANDED
}

@export_group("Weapons Visuals")
@export var main_hand: Mesh
@export var main_hand_collision: ConvexPolygonShape3D
@export var main_hand_handedness: HANDEDNESS
@export var off_hand: Mesh
@export var off_hand_collision: ConvexPolygonShape3D

@export_group("Weapons Properties")
@export var attack_animation: String
@export var attack_range: float 
@export var min_damage: int
@export var max_damage: int
@export var attack_speed: float
@export var attack_cooldown: float
@export var crit_chance: float
@export var crit_multiplier: float
