extends CanvasLayer

@onready var score_label = $MarginContainer/HBoxContainer/ScoreNumberLabel

func _on_score_timer_timeout() -> void:
	score_label.text = str(int(score_label.text) + 1)
