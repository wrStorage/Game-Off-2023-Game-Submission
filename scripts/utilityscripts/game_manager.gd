extends Node

var high_score: int = 0
var previous_run_score: int = 0
var current_run_score: int = 0
const main_menu_scene: PackedScene = preload("res://scenes/gui/main_menu.tscn")
const level_scene: PackedScene = preload("res://scenes/levels/stage_one.tscn")
@onready var score_timer: Timer = $ScoreTimer
@onready var difficulty_timer: Timer = $DifficultyTimer
	
func load_main_menu() -> void:
	difficulty_timer.stop()
	get_tree().change_scene_to_packed(main_menu_scene)
	
func stop_score_timer() -> void:
	score_timer.stop()

func _on_difficulty_timer_timeout() -> void:
	get_tree().call_group("Obstacles", "increase_difficulty")
	get_tree().call_group("Camera", "shake_camera")

func _on_score_timer_timeout() -> void:
	current_run_score += 1
	EventBus.score_changed.emit()

func start_game() -> void:
	current_run_score = 0
	get_tree().change_scene_to_packed(level_scene)
	difficulty_timer.start()
	score_timer.start()

func check_scores() -> void:
	if current_run_score > high_score:
		high_score = current_run_score
		
	previous_run_score = current_run_score
