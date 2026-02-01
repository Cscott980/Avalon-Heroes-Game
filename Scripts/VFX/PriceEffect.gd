class_name PirceEffect extends Node3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func play_price_animation() -> void:
	animation_player.play("PirceAnimation")
