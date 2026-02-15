class_name HeroClassResource extends Resource

@export_group("Settings")
@export var hero_class:HeroClassConstants.HERO_CLASS
var display_name: String = HeroClassConst.load_class_to_string(hero_class)
@export_multiline var description: String = ""
@export var icon: Texture2D

#Defult visuals when character has no armor.
@export_group("Default Visuals")
@export var class_defaults: HeroClassVisualDefaultResource

@export_group("Stats")
@export var max_health: int = 100

@export_group("Stats/Base Stats")
@export var hero_stats: StatResource

@export_group("Stats/ResourcePool")
@export var resource_pool: ResourcePoolResource

@export_group("Abilities")
@export var hero_abilities: HeroClassAbilitiesResource

@export_group("Equipment Rules")
@export var starting_equipment: PlayerEquipmentResource
@export_group("Equipment Rules/Allowed Armor Types")
@export_flags(
	"Light",
	"Medium",
	"Heavy",
	"Shield"
) var allowed_armor_types = 0
@export_group("Equipment Rules/Allowed Weapon Types")
@export_flags(
	"Dagger",
	"Fist Weapon",
	"Scythe",
	"Polearm",
	"Axe",
	"Battleaxe",
	"Sword",
	"Greatsword",
	"Mace",
	"Great Hammer",
	"Bow",
	"Crossbow",
	"Gun",
	"Throwable",
	"Wand",
	"Stave",
	"Relic"
) var allowed_weapons = 0
