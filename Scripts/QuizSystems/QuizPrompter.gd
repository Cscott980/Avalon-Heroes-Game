class_name QuizPrompter extends Control

signal answer_chosen(answer: int)

@export var quiz_manager: QuizManager = null

@onready var chocie_a: Button = %A
@onready var choice_b: Button = %B
@onready var choice_c: Button = %C
@onready var choice_d: Button = %D
@onready var quiz_timer: Timer = $QuizTimer
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var question: String = "No Question Set"
var choices: Array = []

func get_set_question(question: String) -> void:
	pass

func set_choices() -> void:
	pass

func play_promp_appear() -> void:
	pass

func _on_a_pressed() -> void:
	answer_chosen.emit(0)


func _on_b_pressed() -> void:
	answer_chosen.emit(1)


func _on_c_pressed() -> void:
	answer_chosen.emit(2)


func _on_d_pressed() -> void:
	answer_chosen.emit(3)


func _on_quiz_timer_timeout() -> void:
	pass # Replace with function body.
