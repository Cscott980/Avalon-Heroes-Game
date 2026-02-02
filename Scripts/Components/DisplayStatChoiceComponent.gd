class_name DisplayStatChoiceComponent extends Control

signal selected_choice(choice: Dictionary)

@onready var choice_btn_one: TextureButton = %ChoiceBtnOne
@onready var stat_one_icon: TextureRect = %StatOneIcon
@onready var stat_one_name: Label = %StatOneName
@onready var stat_one_disc: Label = %StatOneDisc
@onready var choice_btn_one_2: TextureButton = %ChoiceBtnOne2
@onready var stat_two_icon: TextureRect = %StatTwoIcon
@onready var stat_two_name: Label = %StatTwoName
@onready var stat_two_disc: Label = %StatTwoDisc
@onready var choice_btn_one_3: TextureButton = %ChoiceBtnOne3
@onready var stat_three_icon: TextureRect = %StatThreeIcon
@onready var stat_three_name: Label = %StatThreeName
@onready var stat_three_disc: Label = %StatThreeDisc



var stat_choice_1: String = ""
var stat_choice_2: String = ""
var stat_choice_3: String = ""
var stat_description_1_text:String = "Increase {stat} by {value}%."
var stat_description_2_text:String = "Increase {stat} by {value}%."
var stat_description_3_text:String = "Increase {stat} by {value}%."
var stats_resived: Array = []

var button_style: StyleBox

func _ready() -> void:
	self.visible = false


	
func _on_progression_component_stat_choices(options: Array[Dictionary]) -> void:
	#TODO: Set up a better way to get data and change value to approriate percentages for easy to read by the player.
	stats_resived = options
	stat_choice_1 = stats_resived[0].get("stat", "")
	stat_one_name.text = stat_choice_1
	stat_one_disc.text = stat_description_1_text.format(stats_resived[0])
	stat_choice_2 = stats_resived[1].get("stat", "")
	stat_one_name.text = stat_choice_2
	stat_one_disc.text = stat_description_1_text.format(stats_resived[1])
	stat_choice_3 = stats_resived[2].get("stat", "")
	stat_one_name.text = stat_choice_3
	stat_one_disc.text = stat_description_1_text.format(stats_resived[2])
	self.visible = true

func _on_choice_btn_one_pressed() -> void:
	emit_signal("selected_choice", stats_resived[0])
	stats_resived.clear()
	self.visible = false


func _on_choice_btn_one_2_pressed() -> void:
	emit_signal("selected_choice", stats_resived[1])
	stats_resived.clear()
	self.visible = false


func _on_choice_btn_one_3_pressed() -> void:
	emit_signal("selected_choice", stats_resived[2])
	stats_resived.clear()
	self.visible = false
