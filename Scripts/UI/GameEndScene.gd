class_name GameEndScene extends Control

@onready var enemy_kills: Label = %EnemyKills
@onready var gold_collected: Label = %GoldCollected

@onready var menu_box: HBoxContainer = %PointBox
@onready var clear_music: AudioStreamPlayer = %ClearMusic
@onready var end_screen_player: AnimationPlayer = %EndScreenPlayer
@onready var enemy_counter: AudioStreamPlayer = $EnemyCounter
@onready var gold_sound: AudioStreamPlayer = $GoldSound
@onready var play_again_btn: TextureButton = %PlayAgain
@onready var fade: ColorRect = %Fade

@export var game_manager: GameManager = null

func _ready() -> void:
	game_manager = get_parent()
	play_again_btn.disabled = true
	fade.visible = false
	enemy_kills.text = "0"
	gold_collected.text = "0"

func play_cleared_animation() -> void:
	end_screen_player.play("EndGame")

func _on_play_again_pressed() -> void:
	play_again_btn.disabled = true
	fade.visible = true
	end_screen_player.play("LightFade")
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()

func counter() -> void:
	var final_kills: int = game_manager.enemies_killed
	var final_gold: int = game_manager.player_list[0].get("gold", 0)

	await animate_counter(enemy_kills, 0, final_kills, 1.0, enemy_counter)
	await animate_counter(gold_collected, 0, final_gold, 1.0, gold_sound)

	play_again_btn.disabled = false

func animate_counter(label: Label, from_value: int, to_value: int, duration: float, sound: AudioStreamPlayer = null) -> void:
	var elapsed: float = 0.0
	
	if sound:
		sound.play()
	
	while elapsed < duration:
		var t: float = elapsed / duration
		var value: int = int(round(lerp(float(from_value), float(to_value), t)))
		label.text = str(value)
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	
	label.text = str(to_value)
	
	if sound and sound.playing:
		sound.stop()

func _on_end_screen_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"EndGame":
		counter()
