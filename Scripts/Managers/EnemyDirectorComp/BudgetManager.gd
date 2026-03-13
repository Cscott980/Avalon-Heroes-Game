class_name BudgetManager extends Node


@export var max_budget: int = 20
var base_budget: int = 20

var current_spent = 0

func _ready() -> void:
	base_budget = max_budget

func get_cost(cost: int) -> int:
	return cost

func can_spend(cost: int) -> bool:
	return (current_spent + cost) <= max_budget

func spend(cost: int) -> void:
	current_spent += cost
	
func refund(cost: int) -> void:
	current_spent = max(0, current_spent - cost)
