class_name StatResource extends Resource

@export_group("Base Stats")
@export var strength: int = 0
@export var intellect: int = 0
@export var dexterity: int = 0
@export var vitality: int = 0
@export var wisdom: int = 0

@export_group("Scale Data")
@export var entity_main_stat: StatConst.STATS
