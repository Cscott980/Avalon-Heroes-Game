class_name ItemPullAndPickupComponent extends Node

signal picked_up(body: Player)

@onready var pull_range: Area3D = %PullRange
@export var item_base: Drop = null
@export var item_speed: float

var target: CharacterBody3D = null

func _physics_process(delta: float) -> void:
	if target and item_base:
		item_base.global_position = item_base.global_position.move_toward(target.global_position, item_speed * delta)
		item_base.move_and_collide(item_base.global_position)
		
func _on_pull_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player = body as Player
		if player.hero_class.hero_class in item_base.can_be_seen_by:
			target = player

func _on_pull_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and body == target:
		target = null

func _on_pick_up_range_body_entered(body: Node3D) -> void:
	if body == target:
		picked_up.emit(body as Player)
