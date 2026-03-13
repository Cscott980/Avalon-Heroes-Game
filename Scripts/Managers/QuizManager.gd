class_name QuizManager extends Node

signal question_answered #Player must keep answering question until correct then this will be emited.
signal revive
signal next
signal terminate

enum RESULTS {
	CORRECT,
	INCORRECT,
	TIMED_OUT
}

@onready var correct: TextureRect = %Correct
@onready var incorrect: TextureRect = %Incorrect
@onready var timed_out: TextureRect = %TimedOut
@onready var quiz_prompter: QuizPrompter = %QuizPrompter
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var tool_tip: Label = %ToolTip

@export var quiz_data: Dictionary = {}
@export var time_to_wait: float = 5.0

const RESULT_ANIM: Dictionary = {
	RESULTS.CORRECT: "Correct",
	RESULTS.INCORRECT: "Incorrect",
	RESULTS.TIMED_OUT: "TimedOut"
}

const CORRECT_MESSAGE: String = "Press [Enter] to continue."
var incorrect_message: String = ""
var timed_out_message: String = ""

var questions: Array = []
var answer: int = 0
var current_question: Dictionary
var new_question: Dictionary
var needed: int = 0
var hit: int = 0

var players: Array = []
var level_mode: bool = false
var death_mode: bool = false

var answered: bool = false
var over: bool = false
func _ready() -> void:
	quiz_prompter.visible = false
	correct.visible = false
	incorrect.visible = false
	timed_out.visible = false
	tool_tip.visible = false
	
	players = get_tree().get_nodes_in_group("player")
	var file := FileAccess.open("res://Resources/Quizes/TestQuizVerbs.json", FileAccess.READ)
	if file == null:
		push_error("QuizManager: Could not open quiz file.")
		return

	var text := file.get_as_text()
	var parsed = JSON.parse_string(text)

	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("QuizManager: Parsed quiz data is not a Dictionary.")
		return

	quiz_data = parsed
	questions = quiz_data.get("questions", [])

	for player in players:
		(player as Player).level_phase.connect(_on_player_level_phase)
		(player as Player).death_phase.connect(_on_player_death_phase)
		
func _input(event: InputEvent) -> void:
	if over:
		return
	if not answered:
		return
	if event.is_action_pressed("proceed"):
		next.emit()
	var screen_size = DisplayServer.window_get_size()
	quiz_prompter.size = screen_size
	
func get_question() -> Dictionary:
	if questions.is_empty():
		return {}

	new_question = questions[randi_range(0, questions.size() - 1)]
	if new_question == current_question and questions.size() > 1:
		return get_question()

	current_question = new_question
	answer = current_question.get("answer_index", 0)
	return current_question

func result(choice: int) -> void:
	if not answered:
		return
	if choice == answer:
		if level_mode:
			result_anim(RESULT_ANIM.get(RESULTS.CORRECT),false)
			tool_tip.text = CORRECT_MESSAGE
			await next
			answered = false
			result_anim(RESULT_ANIM.get(RESULTS.CORRECT),true)
			await get_tree().create_timer(1.0).timeout
			quiz_prompter.canvas_layer.visible = false
			quiz_prompter.visible = false
			level_mode = false
			death_mode = false
			question_answered.emit()
			return
		elif death_mode:
			hit += 1
			if hit == needed:
				result_anim(RESULT_ANIM.get(RESULTS.CORRECT),false)
				tool_tip.text = CORRECT_MESSAGE
				await next
				answered = false
				result_anim(RESULT_ANIM.get(RESULTS.CORRECT),true)
				await get_tree().create_timer(1.0).timeout
				quiz_prompter.canvas_layer.visible = false
				quiz_prompter.visible = false
				level_mode = false
				death_mode = false
				revive.emit()
				return
			else: 
				result_anim(RESULT_ANIM.get(RESULTS.CORRECT),false)
				tool_tip.text = CORRECT_MESSAGE
				await next
				answered = false
				result_anim(RESULT_ANIM.get(RESULTS.CORRECT),true)
				await get_tree().create_timer(1.0).timeout
				quiz_prompter.question = get_question()
				quiz_prompter.start_question()
				return

	else:
		result_anim(RESULT_ANIM.get(RESULTS.INCORRECT),false)
		var choices: Array = current_question["options"]
		incorrect_message = "Answer: %s. Press [Enter] to continue." % choices[answer]
		tool_tip.text = incorrect_message
		await next
		answered = false
		result_anim(RESULT_ANIM.get(RESULTS.INCORRECT),true)
		await get_tree().create_timer(1.0).timeout
		quiz_prompter.question = get_question()
		quiz_prompter.start_question()
		return

#Animation Helper
func result_anim(anim: String, reverse: bool) -> void:
	if reverse:
		anim_player.play_backwards(anim)
	else:
		anim_player.play(anim)

func should_abort_quiz() -> bool:
	return over

func _on_player_level_phase() -> void:
	if over:
		return
	needed = 1
	hit = 0
	level_mode = true
	death_mode = false
	quiz_prompter.visible = true
	quiz_prompter.question = get_question()
	quiz_prompter.start_question()

func _on_player_death_phase() -> void:
	if over:
		return
	needed = 3
	hit = 0
	level_mode = false
	death_mode = true
	quiz_prompter.visible = true
	quiz_prompter.question = get_question()
	quiz_prompter.start_question()

func _on_quiz_prompter_answer_chosen(choice: int) -> void:
	if over:
		return
	answered = true
	result(choice)

func _on_quiz_prompter_timed_out() -> void:
	if over:
		return
	answered = true
	result_anim(RESULT_ANIM.get(RESULTS.TIMED_OUT),false)
	var choices: Array = current_question["options"]
	incorrect_message = "Answer: %s. Press [Enter] to continue." % choices[answer]
	tool_tip.text = incorrect_message
	await next
	answered = false
	result_anim(RESULT_ANIM.get(RESULTS.TIMED_OUT),true)
	await get_tree().create_timer(1.0).timeout
	quiz_prompter.question = get_question()
	quiz_prompter.start_question()
	return

func _on_game_manager_game_ended() -> void:
	if over:
		return
	
	over = true
	level_mode = false
	death_mode = false
	answered = false
	
	quiz_prompter.visible = false
	quiz_prompter.canvas_layer.visible = false
	correct.visible = false
	incorrect.visible = false
	timed_out.visible = false
	tool_tip.visible = false
	
	terminate.emit()
