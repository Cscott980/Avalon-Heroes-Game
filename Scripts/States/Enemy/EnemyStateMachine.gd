class_name EnemyStateMachine
extends Node

var current_state: EnemyState
var _states: Dictionary = {}

@export var initial_state_path: NodePath
@onready var enemy: Enemy = get_parent()

func _ready() -> void:	
	for child in get_children():
		if child is EnemyState:
			_states[child.name] = child
			child.enemy = enemy
			child.state_machine = self

func Initializer() -> void: 
	if initial_state_path != NodePath(""):
		var init = get_node(initial_state_path)
		if init is EnemyState:
			current_state = init
			current_state.enter()

func change_state(new_state_name: String) -> void:
	_change_state(new_state_name)

func _change_state(new_state_name: String) -> void:
	var new_state: EnemyState = _states.get(new_state_name)
	
	if new_state == null:
		push_warning("EnemyStateMachine: State %s not found." % new_state_name)
		return
		
	if new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
