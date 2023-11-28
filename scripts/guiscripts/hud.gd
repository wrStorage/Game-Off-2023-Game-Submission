extends CanvasLayer

@onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreNumberLabel

func _ready():
	EventBus.connect("score_changed", adjust_score_label)
	EventBus.connect("player_died", hide)

func adjust_score_label():
	score_label.text = str(GameManager.current_run_score)
