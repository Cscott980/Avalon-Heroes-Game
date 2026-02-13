class_name AbilityBar extends Control


@onready var player_yu: PlayerUI

@onready var ability_1: TextureButton = %Ability1
@onready var cooldown_1: TextureProgressBar = %Cooldown1
@onready var ability_2: TextureButton = %Ability2
@onready var cooldown_2: TextureProgressBar = %Cooldown2
@onready var ability_3: TextureButton = %Ability3
@onready var cooldown_3: TextureProgressBar = %Cooldown3

@onready var ability_one_cooldown_timer: Timer = %AbilityOneCooldownTimer
@onready var ability_two_cooldown_timer: Timer = %AbilityTwoCooldownTimer
@onready var ability_three_cooldown_timer: Timer = %AbilityThreeCooldownTimer

#------- Bars and Levels --------
@onready var player_health: ProgressBar = %PlayerHealth
@onready var resource_bar: ProgressBar = %ResourceBar
@onready var experiance_bar: ProgressBar = %ExperianceBar
@onready var level_ui_dis: Label = %Label

#-------- Controller Icons -------
@onready var btn_label_1: TextureRect = %BtnLabel1
@onready var btn_label_2: TextureRect = %BtnLabel2
@onready var btn_label_3: TextureRect = %BtnLabel3




func _ready() -> void:
	pass

func add_xp(amount: int) ->void:
	pass


func _on_ability_1_pressed() -> void:
	pass # Replace with function body.


func _on_ability_2_pressed() -> void:
	pass # Replace with function body.


func _on_ability_3_pressed() -> void:
	pass # Replace with function body.
