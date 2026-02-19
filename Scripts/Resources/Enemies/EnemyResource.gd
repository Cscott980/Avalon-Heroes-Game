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
@export var animation_tree: AnimationNodeBlendTree
@export var path_name: String
@export_group("Weapons")
@export var combat_type: EnemyType
@export var weapon_data: EnemyWeaponResource

@export_group("Movement")
@export var movement_data: EnemyMovementResource

@export_group("Stats")
@export var max_health: int
@export var stats: StatResource

@export_group("Abilities")
@export var abilities: Array[AbilityResource]

@export_group("Loot Pool")
@export var drop: Array[ResourceVisualsResource]
