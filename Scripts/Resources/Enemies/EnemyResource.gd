class_name EnemyResource extends Resource

enum EnemyType {
	MELEE,
	RANGE,
	SUPPORT
}

@export_group("Info")
@export var name: String
@export var enemy_type: EnemyType

@export_group("Visuals")
@export var enemy_mesh: EnemyVisualsResource

@export_group("Weapons")
@export var main_hand: WeaponResource
@export var off_hand: WeaponResource
@export var other: Mesh

@export_group("Movement")
@export var movement_speed: float
@export var turn_speed: float
@export var wander_speed: float

@export_group("Stats")
@export var stats: StatResource

@export_group("Stats/Resource Pool")
@export var resource: ResourcePoolResource

@export_group("Abilities")
@export var abilities: Array[AbilityResource]

@export_group("Loot Pool")
@export var drop: Array[ResourceVisualsResource]
