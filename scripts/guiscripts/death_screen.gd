extends CanvasLayer

@onready var retry_button: Button = $ScreenOverlay/ButtonMarginContainer/ButtonVerticalContainer/RetryButton
@onready var run_score_label: Label = $ScreenOverlay/ScoreMarginContainer/ScoreHorizontalContainer/RunScoreLabel
@onready var high_score_label: Label = $ScreenOverlay/ScoreMarginContainer/ScoreHorizontalContainer/HighScoreLabel

func _ready() -> void:
	EventBus.connect("player_died", show_death_screen)
	hide()

func _on_retry_button_pressed() -> void:
	GameManager.start_game()
	get_tree().paused = false
	hide()

func _on_visibility_changed() -> void:
	if visible:
		GameManager.stop_score_timer()
		GameManager.check_scores()
		run_score_label.text = "Score\n" + str(GameManager.current_run_score)
		high_score_label.text = "High Score\n" + str(GameManager.high_score)
		retry_button.grab_focus()

func _on_button_focus_exited() -> void:
	if visible:
		SfxAudioPlayer.play_menu_scroll_sfx()
		
func show_death_screen() -> void:
	SfxAudioPlayer.play_death_sfx()
	show()
	get_tree().paused = true
