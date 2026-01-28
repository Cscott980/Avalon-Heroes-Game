class_name ApperanceTypeResource extends Resource

enum SkinColor {
	WHITE,
	BROWN,
	BLACK,
	CREAM,
	RED,
	BLUE
}

enum HairColor {
	BLACK,
	WHITE,
	BLONDE,
	GRAY,
	PINK,
	BROWN,
	RED,
	ORANGE
}

@export var skin_color: SkinColor
@export var hair_color:HairColor
@export var material: Material
