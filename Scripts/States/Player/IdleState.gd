class_name IdleState extends PlayerState

var weapon_is_sheathed: bool = false
var handness: int
var no_weapon_equiped: bool

func enter() -> void:
	pass
func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	if no_weapon_equiped or weapon_is_sheathed:
		playback.play_idle_animation()
	elif handness == WeaponResource.HANDEDNESS.TWO_HANDED:
		playback.play_two_handed_animation()
	elif handness == WeaponResource.HANDEDNESS.ONE_HANDED:
		playback.play_idle_animation()

func _on_player_input_component_sheath_weapon(sheath: bool) -> void:
	weapon_is_sheathed = sheath

func _on_main_hand_weapon_weapon_data(data: WeaponResource) -> void:
	handness = data.handedness

func _on_main_hand_weapon_no_weapon_equiped(status: bool) -> void:
	no_weapon_equiped = status
