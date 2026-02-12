@icon("uid://bhgfggrpib6sa")
class_name ResourcePoolComponent extends Node

signal current_resource_amount(amount: int)
signal resource_used(amount: int)

var resource_data:ResourcePoolResource
