class_name WeaponResource extends ItemResource


enum WEAPON_TYPE {
	DAGGER,
	SCYTHE,
	POLEARM,
	AXE,
	BATTLEAXE,
	SWORD,
	GREATSWORD,
	HAMMER,
	GREAT_HAMMER,
	BOW,
	CROSSBOW,
	THROWABLE,
	WAND,
	STAFF,
	RELIC
}

enum HANDEDNESS {
	ONE_HANDED,
	TWO_HANDED
	}
	
enum ATTCK_TYPE {
	MELEE,
	RANGED
}

@export_group("Settings")
@export var weapon_type: WEAPON_TYPE
@export var handedness: HANDEDNESS = HANDEDNESS.ONE_HANDED
@export var attack_type: ATTCK_TYPE
@export var mesh: Mesh
@export var off_hand_complement_mesh: Mesh
@export var projectile: ProjectileResource
@export var weapon_effect: Shader
@export var collision_shape: Shape3D
@export var muzzle_position:Vector3
@export_flags(
	"main_hand",
	"off_hand"
) var can_be_equippable = 0

@export_group("Stats")
@export var damage: int = 0
@export var stat_effect: StatusEffectsResource
@export_flags(
	"Strength", 
	"Intellect", 
	"Dexterity", 
	"Wisdom" 
	) var scale_on_stat = 0
@export var scale_percentage: float
@export var weapon_speed: float = 0.0
@export var stat_bonus: StatBonusResource
@export_flags(
	"warrior",
	"paladin",
	"mage",
	"ranger",
	"rogue",
	"druid",
	"engineer"
) var allowed_classes = 0

@export_group("Combat Data")
@export var attack_combo: Array[AttackDataResource] = []  # NEW: 3 attacks for the combo


@export_group("Text")
@export_multiline var stat_info: String
