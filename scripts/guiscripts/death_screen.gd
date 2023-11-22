extends CanvasLayer

@onready var retry_button = $ScreenPanel/ButtonMarginContainer/ButtonVerticalContainer/RetryButton
@onready var run_score_label = $ScreenPanel/ScoreMarginContainer/ScoreHorizontalContainer/RunScoreLabel
@onready var high_score_label = $ScreenPanel/ScoreMarginContainer/ScoreHorizontalContainer/HighScoreLabel

func _ready() -> void:
	hide()

func _on_retry_button_pressed() -> void:
	GameManager.reset_run_score()
	GameManager.start_game()
	get_tree().paused = false
	hide()

func _on_main_menu_button_pressed() -> void:
	GameManager.end_game()
	get_tree().paused = false
	hide()

func _on_visibility_changed() -> void:
	if visible:
		GameManager.stop_score_timer()
		GameManager.check_scores()
		run_score_label.text = "Run Score\n" + str(GameManager.current_run_score)
		high_score_label.text = "High Score\n" + str(GameManager.high_score)
		retry_button.grab_focus()

func _on_button_focus_exited() -> void:
	if visible:
		SfxAudioPlayer.play_menu_scroll_sfx()
