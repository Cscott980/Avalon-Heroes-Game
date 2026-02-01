class_name ProgressionComponent extends Node

signal level(current_level:int)
signal stat_selected(stat: int, amount: int)
signal exp_collected(amount: int)

#@export var exp_collector: CollectorComponent

var 
