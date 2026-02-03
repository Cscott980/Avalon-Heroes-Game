class_name DisplayStatChoiceComponent extends Control

signal selected_choice(choice: Dictionary)

@onready var choice_btn_one: TextureButton = %ChoiceBtnOne
@onready var choice_btn_two: TextureButton = %ChoiceBtnOne2
@onready var choice_btn_three: TextureButton = %ChoiceBtnOne3





var stats_recived: Array[Dictionary] = [{}]
var btn_list:Array[TextureButton] = []

func _ready() -> void:
	btn_list = [
		choice_btn_one,
		choice_btn_two,
		choice_btn_three
	]


	
func _on_progression_component_stat_choices(options: Array[Dictionary]) -> void:
	stats_recived = options
	self.visible
	for i in range(stats_recived.size()):
		var data: Dictionary = stats_recived[i]
		
		
		

func _on_choice_btn_one_pressed() -> void:
	emit_signal("selected_choice", stats_recived[0])
	stats_recived.clear()
	self.visible = false


func _on_choice_btn_one_2_pressed() -> void:
	emit_signal("selected_choice", stats_recived[1])
	stats_recived.clear()
	self.visible = false


func _on_choice_btn_one_3_pressed() -> void:
	emit_signal("selected_choice", stats_recived[2])
	stats_recived.clear()
	self.visible = false
