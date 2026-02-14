class_name IdleState extends PlayerState

var weapon_is_sheathed: bool 
var handness: int

func enter() -> void:
	if weapon_is_sheathed or handness == WeaponResource.HANDEDNESS.ONE_HANDED:
		playback.play_idle_animation()
		
	elif  handness == WeaponResource.HANDEDNESS.TWO_HANDED:
		playback.play_two_handed_animation()
		
	else:
		playback.play_idle_animation()
func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	if weapon_is_sheathed or handness == WeaponResource.HANDEDNESS.ONE_HANDED:
		playback.play_idle_animation()
		
	if handness == WeaponResource.HANDEDNESS.TWO_HANDED:
		playback.play_two_handed_animation()
		
func _on_player_input_component_sheath_weapon(sheath: bool) -> void:
	weapon_is_sheathed = sheath

func _on_main_hand_weapon_weapon_data(data: WeaponResource) -> void:
	handness = data.handedness
