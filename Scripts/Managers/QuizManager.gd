class_name QuizManager extends Node

signal question_answered #Player must keep answering question until correct then this will be emited.
signal revive
signal next

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

@export var quiz_data: Dictionary = {}
@export var time_to_wait: float = 5.0

const RESULT_ANIM: Dictionary = {
	RESULTS.CORRECT: "Correct",
	RESULTS.INCORRECT: "Incorrect",
	RESULTS.TIMED_OUT: "TimedOut"
}

var questions: Array = []
var answer: int = 0
var current_question: Dictionary
var new_question: Dictionary
var needed: int = 0
var hit: int = 0

var players: Array = []
var level_mode: bool = false
var death_mode: bool = false


func _ready() -> void:
	quiz_prompter.visible = false
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
	if event.is_action_pressed("proceed"):
		next.emit()

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
	if choice == answer:
		if level_mode:
			result_anim(RESULT_ANIM.get(RESULTS.CORRECT))
			await next
			quiz_prompter.visible = false
			level_mode = false
			death_mode = false
			question_answered.emit()
		elif death_mode:
			hit += 1
			if hit == needed:
				result_anim(RESULT_ANIM.get(RESULTS.CORRECT))
				await next
				quiz_prompter.visible = false
				level_mode = false
				death_mode = false
				revive.emit()
			else: 
				result_anim(RESULT_ANIM.get(RESULTS.CORRECT))
				await next
				quiz_prompter.question = get_question()
				quiz_prompter.start_question()
			
	else:
		result_anim(RESULT_ANIM.get(RESULTS.INCORRECT))
		await next
		quiz_prompter.question = get_question()
		quiz_prompter.start_question()

#Animation Helper
func result_anim(anim: String) -> void:
	anim_player.play(anim)

func _on_player_level_phase() -> void:
	needed = 1
	hit = 0
	level_mode = true
	death_mode = false
	quiz_prompter.visible = true
	quiz_prompter.question = get_question()
	quiz_prompter.start_question()

func _on_player_death_phase() -> void:
	needed = 3
	hit = 0
	level_mode = false
	death_mode = true
	quiz_prompter.visible = true
	quiz_prompter.question = get_question()
	quiz_prompter.start_question()

func _on_quiz_prompter_answer_chosen(choice: int) -> void:
	result(choice)

func _on_quiz_prompter_timed_out() -> void:
	result_anim(RESULT_ANIM.get(RESULTS.TIMED_OUT))
	await get_tree().create_timer(time_to_wait).timeout
	quiz_prompter.question = get_question()
	quiz_prompter.start_question()
	
