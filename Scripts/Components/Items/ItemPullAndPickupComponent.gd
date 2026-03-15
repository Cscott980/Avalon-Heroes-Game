class_name ItemPullAndPickupComponent extends Node3D

signal picked_up(body: Player)

@onready var activation_timer: Timer = %ActivationTimer
@onready var pull_coll: CollisionShape3D = %PullColl
@onready var pick_up_coll: CollisionShape3D = %PickUpColl
@onready var pull_range: Area3D = %PullRange

@export var item_base: Drop = null
@export var item_speed: float

var target: CharacterBody3D = null
var direction: Vector3 = Vector3.ZERO
var can_be_pulled: bool
var not_fully_healed: bool


func _ready() -> void:
	activation_timer.start()

func turn_on_collision() -> void:
	pull_coll.set_deferred("disabled", false)
	pick_up_coll.set_deferred("disabled", false)

func turn_off_collision() -> void:
	pull_coll.set_deferred("disabled", true)
	pick_up_coll.set_deferred("disabled", true)

func _physics_process(delta: float) -> void:
	if not target or not can_be_pulled or not item_base:
		return
	
	direction = (target.global_position - item_base.global_position).normalized()
	var distance: float = item_base.global_position.distance_to(target.global_position)
	
	if distance > 0.5:			
		item_base.linear_velocity = item_base.linear_velocity.lerp(direction * item_speed, delta * 10.0)

func _on_pull_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player = body as Player
		if not player.drop_pickup_component.can_pick_up:
			return
			
		if item_base.drop_type == ItemDropResource.DROP_TYPE.HEALTH_POT:
			if player.health_component.health == player.health_component.max_health:
				return
				
		target = player

func _on_pull_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and body == target:
		target = null

func _on_pick_up_range_body_entered(body: Node3D) -> void:
	var player: Player = body
	if not player.drop_pickup_component.can_pick_up:
		return
			
	if item_base.drop_type == ItemDropResource.DROP_TYPE.HEALTH_POT:
		if player.health_component.health == player.health_component.max_health:
			return
			
	if body == target:
		picked_up.emit(body as Player)

func _on_activation_timer_timeout() -> void:
	can_be_pulled = true
