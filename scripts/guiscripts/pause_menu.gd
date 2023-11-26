extends CanvasLayer

@onready var resume_button: Button = $PausePanel/ButtonMarginContainer/ButtonVerticalContainer/ResumeButton

func _input(event: InputEvent):
	if event.is_action_pressed("pause") and get_tree().paused == false:
		show()
		get_tree().paused = true
	elif event.is_action_pressed("pause") and get_tree().paused == true:
		hide()
		get_tree().paused = false

func _ready() -> void:
	EventBus.connect("player_died", queue_free)
	hide()

func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false

func _on_visibility_changed() -> void:
	if visible:
		resume_button.grab_focus()

func _on_main_menu_button_pressed() -> void:
	GameManager.stop_score_timer()
	GameManager.load_main_menu()
	get_tree().paused = false

func _on_button_focus_entered() -> void:
	SfxAudioPlayer.play_menu_scroll_sfx()
