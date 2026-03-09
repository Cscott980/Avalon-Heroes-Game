class_name QuizManager extends Node

signal question_answered #Player must keep answering question until correct then this will be emited.


@onready var correct: TextureRect = %Correct
@onready var incorrect: TextureRect = %Incorrect
@onready var timed_out: TextureRect = %TimedOut
@onready var quiz_prompter: QuizPrompter = %QuizPrompter

@export var quiz_data: JSON = null

var questions: Array = []

func _ready() -> void:
	questions = quiz_data.get("questions")
	
func get_question() -> Dictionary:
	var question: Dictionary = questions[randi_range(0, questions.size())]
	return question


func _on_player_level_phase() -> void:
	pass
