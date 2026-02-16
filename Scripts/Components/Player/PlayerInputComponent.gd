@icon("uid://y6xubei2ho8r")
class_name PlayerInputComponent extends Node

signal move_intent_changed(intent: Vector3)
signal attack
signal block_started
signal block_ended
signal charsheet_toggled
signal sheath_weapon(sheath: bool)


var move_intent: Vector3 = Vector3.ZERO
var _last_move_intent: Vector3 = Vector3.ZERO
var is_sheathed: bool = false
var inventroy_open: bool = false

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	var x: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var z: float = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	move_intent = Vector3(x, 0.0, z)
	
	if move_intent.length() > 0.1:
		move_intent = move_intent
		
	if move_intent != _last_move_intent:
		_last_move_intent = move_intent
		move_intent_changed.emit(move_intent)

func _input(event: InputEvent) -> void:
	#----- UI Input ---------
	if event.is_action_pressed("inventory"):
		charsheet_toggled.emit()
	
	if event.is_action_pressed("sheeth"):
		if not is_sheathed:
			is_sheathed = true
			sheath_weapon.emit(is_sheathed)
		else:
			is_sheathed = false
			sheath_weapon.emit(is_sheathed)

	#----- Combat Input ---------
	if event.is_action_pressed("base_attack"):
		attack.emit()
	
	if event.is_action_pressed("block"):
		block_started.emit()
	elif event.is_action_released("block"):
		block_ended.emit()
