class_name ItemResource extends Resource

@export var name: String
@export var id: String
@export_multiline var description: String
@export var icon: Texture2D
@export_enum(
	"None",
	"Common",
	"Uncommon",
	"Rare",
	"Epic",
	"Legendary",
	"Chroma"
	) var rarity: String = "None"
@export_enum(
	"Weapon",
	"Armor",
	"Resource",
	"Consumable",
	"Quest",
	"Material"
) var item_type

@export var stackable: bool
@export var max_stack: int
