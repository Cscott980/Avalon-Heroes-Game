class_name ItemPanel extends PanelContainer

@export var item_data: ItemResource

#---- SWITCHES --- 
@onready var armor_type: HBoxContainer = %ArmorType
@onready var weapon_type: HBoxContainer = %WeaponType
@onready var class_armor: HBoxContainer = %ClassArmor
@onready var properties: VBoxContainer = %Properties
@onready var market_data: HBoxContainer = %MarketData
#-----------------

@onready var item_name: Label = %ItemName
@onready var a_type: Label = %AType
@onready var w_type: Label = %WType
@onready var class_type: Label = %ClassType
@onready var specials: Label = %Specials
@onready var strength_value: Label = %StrengthValue
@onready var intellect_value: Label = %IntellectValue
@onready var wisdom_value: Label = %WisdomValue
@onready var vitality_value: Label = %VitalityValue
@onready var flavo_ttext: Label = %FlavoTtext
@onready var price: Label = %Price

func _ready() -> void:
	pass

func set_item(i: ItemResource) -> void:
	pass

func get_armor_data() -> void:
	pass

func get_weapon_data() -> void:
	pass
