extends Control

const level_scene = preload("res://scenes/levels/stage_one.tscn")
@onready var high_score_label = $ScorePanel/HighScoreLabel
@onready var previous_score_label = $ScorePanel/PreviousScoreLabel
@onready var start_button = $VerticalButtonContainer/StartButton

func _ready() -> void:
	start_button.grab_focus()
	high_score_label.text = "High Score: " + str(GameManager.high_score)
	previous_score_label.text = "Last Run Score: " + str(GameManager.previous_run_score)

func _on_start_button_pressed() -> void:
	GameManager.start_game()
	
func _on_button_focus_entered():
	SfxAudioPlayer.play_menu_scroll_sfx()
