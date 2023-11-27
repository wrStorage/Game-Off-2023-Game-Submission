extends Control

const level_scene: PackedScene = preload("res://scenes/levels/stage_one.tscn")
@onready var high_score_label: Label = $ScorePanel/HighScoreLabel
@onready var previous_score_label: Label = $ScorePanel/PreviousScoreLabel
@onready var start_button: Button = $VerticalButtonContainer/StartButton
@onready var mute_button: Button = $VerticalButtonContainer/MuteButton

func _ready() -> void:
	EventBus.connect("mute_button_pressed", change_mute_button_text)
	change_mute_button_text()
	start_button.grab_focus()
	high_score_label.text = "High Score: " + str(GameManager.high_score)
	previous_score_label.text = "Last Run Score: " + str(GameManager.previous_run_score)

func _on_start_button_pressed() -> void:
	GameManager.start_game()
	
func _on_button_focus_entered() -> void:
	SfxAudioPlayer.play_menu_scroll_sfx()

func _on_mute_button_pressed() -> void:
	EventBus.mute_button_pressed.emit()

func change_mute_button_text() -> void:
	if SfxAudioPlayer.volume_muted == true:
		mute_button.text = "Unmute"
	else:
		mute_button.text = "Mute"
