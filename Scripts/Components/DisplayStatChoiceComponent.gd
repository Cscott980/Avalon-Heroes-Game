class_name DisplayStatChoiceComponent extends Control

signal selected_choice(choice: Dictionary)

@onready var choice_btn_one: ChoiceBtn = %ChoiceBtnOne
@onready var choice_btn_two: ChoiceBtn = %ChoiceBtnOne2
@onready var choice_btn_three: ChoiceBtn = %ChoiceBtnOne3



var stats_recived: Array[Dictionary] = [{}]
var btn_list:Array[TextureButton] = []
var stat_info: String = "Increase {stat} by {value}%."

func _ready() -> void:
	btn_list = [
		choice_btn_one,
		choice_btn_two,
		choice_btn_three
	]

func data_box(index: int) -> void:
	var selected: Dictionary = stats_recived[index]
	emit_signal("selected_choice", selected)
	stats_recived.clear()
	self.visible = false
	
func convert_percentage(value: float) -> float:
	return value * 100
	
func _on_progression_component_stat_choices(options: Array[Dictionary]) -> void:
	if options.is_empty():
		push_warning("DisplayStatChoiceComponent: No options aviliable.")
		return
	stats_recived = options
	self.visible = true
	for i in range(stats_recived.size()):
		var dic: Dictionary = {"stat": stats_recived[i].get("stat", ""), "value": convert_percentage(stats_recived[i].get("value", 0.0))}
		var stat: String= dic.get("stat", "")
		var disc :String = stat_info.format(dic)
		var icon: String = StatConst.ICON_REFERANCE.get(StatConst.load_stats_int(dic[stat]))
		if btn_list[i].has_method("set_choice_visual_data"):
			btn_list[i].set_choice_visual_data(icon, stat, disc)
		
func _on_choice_btn_one_pressed() -> void:
	data_box(0)

func _on_choice_btn_one_2_pressed() -> void:
	data_box(1)

func _on_choice_btn_one_3_pressed() -> void:
	data_box(2)
	
