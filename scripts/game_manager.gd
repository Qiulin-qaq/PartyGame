extends Node

@onready var score_label: Label = $"../Player/Camera2D/ScoreLabel"

var score = 0	

func add_score():
	score += 1
	score_label.text = "得分: " + str(score)
	print(score)
