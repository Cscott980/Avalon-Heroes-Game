class_name EnemyResource extends Resource

enum EnemyType {
	MELEE,
	RANGE,
	SUPPORT
}

@export_group("Info")
@export var name: String

@export_group("Visuals")
@export var enemy_mesh: EnemyVisualsResource

@export_group("Weapons")
@export var combat_type: EnemyType
@export var main_hand: Mesh
@export var off_hand: Mesh
@export var other: Mesh
@export var damage: int
@export var attack_speed: float
@export var attack_cooldown: float

@export_group("Movement")
@export var movement_speed: float
@export var turn_speed: float
@export var wander_speed: float

@export_group("Stats")
@export var max_health: int
@export var stats: StatResource

@export_group("Abilities")
@export var abilities: Array[AbilityResource]

@export_group("Loot Pool")
@export var drop: Array[ResourceVisualsResource]
