class_name DamageTypesConstants extends Node

enum TYPES {
	DAMAGE,
	CRIT,
	HEAL,
	POISON,
	FIRE,
	FROST,
	SHADOW,
	EXPLOSIVE
}

const TYPE_COLORS: Dictionary = {
	TYPES.DAMAGE: Color.WHITE,
	TYPES.CRIT: Color.CRIMSON,
	TYPES.HEAL: Color.GREEN,
	TYPES.POISON: Color.WEB_GREEN,
	TYPES.FIRE: Color.ORANGE_RED,
	TYPES.FROST: Color.DODGER_BLUE,
	TYPES.SHADOW: Color.PURPLE,
	TYPES.EXPLOSIVE: Color.ORANGE
}

func load_type_color(type: int) -> Color:
	return TYPE_COLORS.get(type, Color.GRAY)
