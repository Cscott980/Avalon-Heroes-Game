class_name BudgetManager extends Node


@export var max_budget: int = 20
var current_spent = 0

@export var enemy_cost: Dictionary = {
	&"grunt": 1,
	&"elite": 5
}

func get_cost(enemy_id: StringName) -> int:
	return int(enemy_cost.get(enemy_id,1))

func can_spend(cost: int) -> bool:
	return (current_spent + cost) <= max_budget

func spend(cost: int) -> void:
	current_spent += cost
	
func refund(cost: int) -> void:
	current_spent = max(0, current_spent - cost)
