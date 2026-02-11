@icon("uid://bcmnnidtwjut6")
class_name PlayerStateMachine extends Node

var current_state: PlayerState
var _states: Dictionary = {}
@export var playback: PlyaerAnimationComponent
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
