extends Node3D

@export var play: bool = false
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func play_slash() -> void:
	if play:
		animation_player.play("Slash")
