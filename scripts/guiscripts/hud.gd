extends CanvasLayer

@onready var score_label = $MarginContainer/HBoxContainer/ScoreNumberLabel

func _process(delta):
	score_label.text = str(GameManager.current_run_score)
