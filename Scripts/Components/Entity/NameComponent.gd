class_name NameComponent extends Node

@export var name_label: Label = null
@export var entity_name: String

func _ready() -> void:
	name_label.text = entity_name
