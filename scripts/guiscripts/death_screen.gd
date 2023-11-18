extends CanvasLayer

@onready var retry_button = $ScreenPanel/ButtonMarginContainer/ButtonVerticalContainer/RetryButton

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
		retry_button.grab_focus()
