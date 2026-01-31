class_name AbilityBar extends Control


@onready var ability_1: TextureButton = %Ability1
@onready var cooldown_1: TextureProgressBar = %Cooldown1
@onready var ability_2: TextureButton = %Ability2
@onready var cooldown_2: TextureProgressBar = %Cooldown2
@onready var ability_3: TextureButton = %Ability3
@onready var cooldown_3: TextureProgressBar = %Cooldown3

#------- Bars and Levels --------
@onready var player_health: ProgressBar = %PlayerHealth
@onready var resource_bar: ProgressBar = %ResourceBar
@onready var experiance_bar: ProgressBar = %ExperianceBar
@onready var level_ui_dis: Label = %Label

#Controller Icons
#TODO: Set up sungleton with Btn IMG.
@onready var btn_label_1: TextureRect = %BtnLabel1
@onready var btn_label_2: TextureRect = %BtnLabel2
@onready var btn_label_3: TextureRect = %BtnLabel3
