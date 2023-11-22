extends CanvasLayer

@onready var resume_button = $PausePanel/ButtonMarginContainer/ButtonVerticalContainer/ResumeButton

func _ready() -> void:
	hide()

func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false

func _on_visibility_changed() -> void:
	if visible:
		resume_button.grab_focus()

func _on_main_menu_button_pressed() -> void:
	GameManager.stop_score_timer()
	GameManager.reset_run_score()
	GameManager.load_main_menu()
	get_tree().paused = false

func _on_button_focus_entered():
	SfxAudioPlayer.play_menu_scroll_sfx()
