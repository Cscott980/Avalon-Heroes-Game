class_name ItemPullAndPickupComponent extends Node

signal picked_up(body: Player)

@onready var pull_range: Area3D = %PullRange
@export var item_base: Node3D = null
@export var item_speed: float

var target: CharacterBody3D = null

func _physics_process(delta: float) -> void:
	if target and item_base:
		var dir = (target.global_position - item_base.global_position).normalized()
		item_base.global_position = item_base.global_position.move_toward(target.global_position, item_speed * delta)

func _on_pull_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = body

func _on_pull_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and body == target:
		target = null

func _on_pick_up_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and body == target:
		picked_up.emit(body as Player)
