class_name CharacterCreator extends Node3D


#------- Character Visuals ----------
@onready var arm_left: MeshInstance3D = %ArmLeft
@onready var arm_right: MeshInstance3D = %ArmRight
@onready var helm: MeshInstance3D = %Helm
@onready var armor: MeshInstance3D = %Armor
@onready var head: MeshInstance3D = %Head
@onready var leg_left: MeshInstance3D = %LegLeft
@onready var leg_right: MeshInstance3D = %LegRight
@onready var main_hand: BoneAttachment3D = %MainHand
@onready var off_hand: BoneAttachment3D = %OffHand

#-------- Animation -----------
@onready var character_anim_tree: AnimationTree = %AnimationTree
@onready var ui_controler: AnimationPlayer = $AnimationPlayer
#-------- UIButtons ----------
@onready var paladin: Button = %Paladin
@onready var mage: Button = %Mage
@onready var ranger: Button = %Ranger
@onready var rogue: Button = %Rogue
@onready var druid: Button = %Druid
@onready var engineer: Button = %Engineer
@onready var head_left: TextureButton = %HeadLeft
@onready var head_right: TextureButton = %HeadRight
@onready var color_left: TextureButton = %ColorLeft
@onready var color_right: TextureButton = %ColorRight
@onready var confirm_button: TextureButton = %ConfirmButton

#-------- UI Text --------------
@onready var label: Label = %Label
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var head_name: Label = %HeadName
@onready var color_name: Label = %ColorName

#------ UI Boxes ----------------
@onready var apperances: MarginContainer = %Apperances
@onready var class_picker: MarginContainer = %ClassPicker
@onready var class_info: MarginContainer = %ClassInfo
@onready var nickname_container: VBoxContainer = %"Nickname container"

#-------- PlayerNickname -------
@onready var in_line: LineEdit = %InLine

var class_mesh_defults: Dictionary = {}
var head_meshes: Dictionary = {}
var character_visuals: Dictionary = {}
var player_starting_equipment: Dictionary = {}
var player_character_name: String = ""
var class_hero_info: String = ""



func _ready() -> void:
	apperances.visible = false
	class_mesh_defults = GameData.class_visual_defults.get("class_visual_defults", {})
	
	character_visuals = {
		"Head": head.mesh,
		"Armor": [
			arm_right.mesh,
			arm_left.mesh,
			armor.mesh,
			leg_right.mesh,
			leg_left.mesh
			],
		"main_hand": Node3D,
		"off_hand": Node3D
		}
	

func _change_hero(hero_class: String) -> void:
	pass

func save_player_choice(choices: Dictionary) -> Dictionary:
	return {}

func _get_class_defult_data(data: Dictionary) -> Dictionary:
	return {}

func _on_warrior_pressed() -> void:
	_change_hero("warrior")


func _on_paladin_pressed() -> void:
	_change_hero("paladin")


func _on_mage_pressed() -> void:
	_change_hero("mage")


func _on_ranger_pressed() -> void:
	_change_hero("ranger")


func _on_rogue_pressed() -> void:
	_change_hero("rogue")


func _on_druid_pressed() -> void:
	_change_hero("druid")


func _on_engineer_pressed() -> void:
	_change_hero("engineer")


func _on_confirm_button_pressed() -> void:
	pass # Replace with function body.
