class_name ChoiceBtn extends TextureButton

@onready var panel_container: PanelContainer = $PanelContainer
@onready var stat_icon: TextureRect = $PanelContainer/VBoxContainer/StatIcon
@onready var stat_name: Label = $PanelContainer/VBoxContainer/StatName
@onready var stat_disc: Label = $PanelContainer/VBoxContainer/StatDisc

#var choice_panel_resource: ChoicePanelResource

func set_choice_visual_data(icon: Texture2D, name: String, disc: String ) -> void:
		stat_icon.texture = icon
		stat_name.text = name
		stat_disc.text = disc
