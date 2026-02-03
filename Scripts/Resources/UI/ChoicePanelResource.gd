class_name ChoicePanelResource extends RefCounted

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY,
	CHROMA
}

@export var type: Rarity
@export var style_box: StyleBox
