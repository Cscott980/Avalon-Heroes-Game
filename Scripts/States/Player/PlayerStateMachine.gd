@icon("uid://bcmnnidtwjut6")
class_name PlayerStateMachine extends Node




var current_state: PlayerState
var _states: Dictionary = {}
var is_attacking: bool = false
var combo_1_open: bool = true
var combo_2_open: bool = false
var combo_3_open: bool = false


@export var initial_state_path: NodePath


func _ready() -> void:	
	for child in get_children():
		if child is PlayerState:
			_states[child.name] = child
			
func Initializer() -> void: 
	if initial_state_path != NodePath(""):
		var init = get_node(initial_state_path)
		if init is PlayerState:
			current_state = init
			current_state.enter()

func change_state(new_state_name: String) -> void:
	_change_state(new_state_name)

func _change_state(new_state_name: String) -> void:
	var new_state: PlayerState = _states.get(new_state_name)
	
	if new_state == null:
		push_warning("PlayerStateMachine: State %s not found." % new_state_name)
		return
		
	if new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()


func _on_attack_cooldown_timeout() -> void:
	pass


func _on_combo_timer_timeout() -> void:
	combo_1_open = true
	combo_2_open = false
	combo_3_open = false
