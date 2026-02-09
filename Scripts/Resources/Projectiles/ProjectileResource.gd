class_name ProjectileResource extends Resource

enum PROJECTILE_TYPE {
	ARROW,
	MAGIC,
	THROWABLE
}

@export_group("Settings")
@export var name: String
@export var status_effect: StatusEffectsResource
@export var scene: PackedScene
