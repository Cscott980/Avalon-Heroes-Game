@icon("uid://7jvjvq8mqr0")
class_name WorldCollision extends CollisionShape3D

@export var user: CharacterBody3D

var player_layer = 2
var dead_layer = 9

func _on_health_component_dead() -> void:
	user.set_collision_layer_value(dead_layer, true)
	user.set_collision_layer_value(player_layer, false)
	


func _on_health_component_revived() -> void:
	user.set_collision_layer_value(player_layer, true)
	user.set_collision_layer_value(dead_layer, false)
