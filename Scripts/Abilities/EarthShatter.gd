class_name WarriorEarthShatter extends Node3D

@onready var aoe: Area3D = $AOE
@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export var ability_name: StringName = &"EarthShatterAbility"

var damage: int = 1


func _ready() -> void:
	if aoe and not aoe.area_entered.is_connected(_on_aoe_area_entered):
		aoe.area_entered.connect(_on_aoe_area_entered)

	if anim_player:
		if not anim_player.animation_finished.is_connected(_on_animation_player_animation_finished):
			anim_player.animation_finished.connect(_on_animation_player_animation_finished)

	
	anim_player.play(ability_name)

func apply_payload(d: int) -> void:
	damage = d

func _on_aoe_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy") and not area.is_in_group("dead_enemies"):
		var hit_comp: EnemyHurtBoxComponent = area.get_parent()
		hit_comp.damage_recived.emit(damage)
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == ability_name:
		queue_free()
