extends CanvasLayer

@onready var resume_button: Button = $ScreenOverlay/ButtonMarginContainer/ButtonVerticalContainer/ResumeButton

func _notification(what) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and get_tree().paused == false:
		toggle_pause()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func _ready() -> void:
	EventBus.connect("player_died", queue_free)
	hide()

func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false

func _on_visibility_changed() -> void:
	if visible:
		resume_button.grab_focus()

func _on_button_focus_entered() -> void:
	SfxAudioPlayer.play_menu_scroll_sfx()

func toggle_pause() -> void:
	if get_tree().paused == false:
		show()
		get_tree().paused = true
	elif get_tree().paused == true:
		hide()
		get_tree().paused = false
