extends Node3D

@onready var pointer: CPUParticles3D = $CPUParticles3D


func _ready() -> void:
	pointer.emitting = true
