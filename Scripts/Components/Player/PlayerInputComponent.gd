@icon("uid://y6xubei2ho8r")
class_name PlayerInputComponent extends Node

signal move_intent_changed(intent: Vector3)
signal ground_move_requested(data: Dictionary)
signal attack_target_requested(target: Enemy) #click on targets
signal attack #space_bar attacks
signal move_to_target(data: Dictionary)
signal block_started
signal block_ended
signal charsheet_toggled
signal sheath_weapon(sheath: bool)

@export var camera: CameraEffect = null
@export var targets_in_range_component: TargetsInRangeComponent = null
@export var player_ui: MainUI = null

var move_intent: Vector3 = Vector3.ZERO
var _last_move_intent: Vector3 = Vector3.ZERO
var is_sheathed: bool = false
var inventroy_open: bool = false
var input_active: bool = true


func _physics_process(_delta: float) -> void:
	if not input_active:
		return

	var x: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var z: float = Input.get_action_strength("down") - Input.get_action_strength("up")

	move_intent = Vector3(x, 0.0, z)

	if move_intent.length() > 0.1:
		move_intent = move_intent.normalized()
	else:
		move_intent = Vector3.ZERO

	if move_intent != _last_move_intent:
		_last_move_intent = move_intent
		move_intent_changed.emit(move_intent)

	if Input.is_action_just_pressed("block"):
		block_started.emit()
	elif Input.is_action_just_released("block"):
		block_ended.emit()

	# hold-to-move only for ground
	if Input.is_action_pressed("left_click_to_move_and_attack") and not is_mouse_over_ui():
		var data := camera.move_to_mouse()

		if data.hit and not (data.collider and data.collider.is_in_group("enemy")):
			ground_move_requested.emit(data)
			move_to_target.emit(data)

func _input(event: InputEvent) -> void:
	if not input_active:
		return

	if event.is_action_pressed("left_click_to_move_and_attack"):
		if is_mouse_over_ui():
			return

		var data := camera.move_to_mouse()
		
		if data.hit:
			var enemy := get_enemy_from_hit(data.collider)

			if enemy == null:
				enemy = targets_in_range_component.get_best_click_target(data.position)

			if enemy != null:
				attack_target_requested.emit(enemy)
			else:
				ground_move_requested.emit(data)
				move_to_target.emit(data)
				camera.play_pointer_effect(data.position)
	
	if event.is_action_pressed("space(base_attack)"):
		attack_target_requested.emit(null)
	
	
	# UI input
	if event.is_action_pressed("inventory"):
		charsheet_toggled.emit()

	if event.is_action_pressed("sheeth"):
		is_sheathed = not is_sheathed
		sheath_weapon.emit(is_sheathed)

func is_mouse_over_ui() -> bool:
	return get_viewport().gui_get_hovered_control() != null or player_ui.inventory_equipment.is_dragging

func get_enemy_from_hit(node: Node) -> Enemy:
	var current: Node = node
	
	while current != null:
		if current is Enemy:
			return current as Enemy
		current = current.get_parent()
	
	return null

func _on_health_component_dead() -> void:
	input_active = false

func _on_progression_component_leveling(status: bool) -> void:
	input_active = not status

func _on_health_component_revived() -> void:
	input_active = true
