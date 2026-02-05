class_name PlayerInputComponent extends Node

signal block
signal not_blocking

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("block"):
		emit_signal("block")
	else:
		emit_signal("not_blocking")
