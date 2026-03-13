class_name CurrencyComponent extends Control

signal current_gold(amt: int)

@onready var gold_text: Label = %GoldText

var gold: int = 0


func _ready() -> void:
	gold_text.text = str(gold)
	current_gold.emit(gold)

func gold_collected(amount: int) -> void:
	gold += amount
	gold_text.text = str(gold)
	current_gold.emit(gold)
