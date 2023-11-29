extends Control

const level_scene: PackedScene = preload("res://scenes/levels/stage_one.tscn")
@onready var high_score_label: Label = $ScorePanel/HighScoreLabel
@onready var previous_score_label: Label = $ScorePanel/PreviousScoreLabel
@onready var start_button: Button = $VerticalButtonContainer/StartButton
@onready var instructions_button: Button = $VerticalButtonContainer/InstructionsButton

func _ready() -> void:
	EventBus.connect("clicked_off_screen", instructions_button.grab_focus)
	start_button.grab_focus()
	high_score_label.text = "High Score: " + str(GameManager.high_score)
	previous_score_label.text = "Previous Score: " + str(GameManager.previous_run_score)

func _on_start_button_pressed() -> void:
	GameManager.start_game()
	
func _on_button_focus_entered() -> void:
	SfxAudioPlayer.play_menu_scroll_sfx()

func _on_instructions_button_pressed() -> void:
	focus_mode = FOCUS_CLICK
	EventBus.instructions_clicked.emit()

func _on_focus_entered() -> void:
	focus_mode = FOCUS_NONE
	instructions_button.grab_focus()
