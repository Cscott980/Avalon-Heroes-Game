class_name QuizPrompter extends Control

signal answer_chosen(choice: int)
signal timed_out

@export var quiz_manager: QuizManager = null

@onready var chocie_a: Button = %A
@onready var choice_b: Button = %B
@onready var choice_c: Button = %C
@onready var choice_d: Button = %D
@onready var quiz_timer: Timer = $QuizTimer
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var time_dis: Label = %TimeDis

@onready var timer: ProgressBar = %ProgressBar
@onready var prompt_dis: Label = %Label



@export var delay: float = 3.0

var question: Dictionary
var prompt: String = "No Question"
var time: float = 10.0
var choices: Array= []
var buttons: Array[Button] = []

var question_active: bool = false

func _ready() -> void:
	buttons = [
		chocie_a,
		choice_b,
		choice_c,
		choice_d
	]

func _process(_delta: float) -> void:
	if question_active:
		timer.value = quiz_timer.time_left
		time_dis.text = str(int(quiz_timer.time_left))
		

func start_question() -> void:
	if question.is_empty():
		return
		
	question_active = false
	deactivate_buttons()
	set_question()
	set_choices()
	set_timer()
	timer.max_value = time
	timer.value = time
	play_promp_appear(false)

func activate_buttons() -> void:
	for button in buttons:
		button.disabled = false

func deactivate_buttons() -> void:
	for button in buttons:
		button.disabled = true

func set_question() -> void:
	if question.is_empty():
		return
	prompt = question.get("question", "")
	prompt_dis.text = prompt

func set_choices() -> void:
	choices = question.get("options", [])
	for i in range(choices.size()):
		buttons[i].text = choices[i]

func set_timer() -> void:
	time = question.get("time_limit", 0.0)
	quiz_timer.wait_time = time

func play_promp_appear(reverse: bool) -> void:
	if reverse:
		anim_player.play_backwards("QuestionAppear")
	else:
		anim_player.play("QuestionAppear")

func _on_a_pressed() -> void:
	answer_chosen.emit(0)
	play_promp_appear(true)
	quiz_timer.stop()

func _on_b_pressed() -> void:
	answer_chosen.emit(1)
	play_promp_appear(true)
	quiz_timer.stop()

func _on_c_pressed() -> void:
	answer_chosen.emit(2)
	play_promp_appear(true)
	quiz_timer.stop()

func _on_d_pressed() -> void:
	answer_chosen.emit(3)
	play_promp_appear(true)
	quiz_timer.stop()

func _on_quiz_timer_timeout() -> void:
	timed_out.emit()
	play_promp_appear(true)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"QuestionAppear" and not question_active:
		await get_tree().create_timer(delay).timeout
		activate_buttons()
		quiz_timer.start()
		question_active = true
