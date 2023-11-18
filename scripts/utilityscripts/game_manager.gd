extends Node

var high_score = 0
var previous_run_score = 0
var current_run_score = 0
const main_menu_scene = preload("res://scenes/gui/main_menu.tscn")
const level_scene = preload("res://scenes/levels/stage_one.tscn")
@onready var score_timer = $ScoreTimer

func reset_run_score() -> void:
	current_run_score = 0
	
func load_main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
	
func stop_score_timer() -> void:
	score_timer.stop()

func _on_difficulty_timer_timeout() -> void:
	get_tree().call_group("Obstacles", "increase_difficulty")

func _on_score_timer_timeout() -> void:
	current_run_score += 1

func start_game() -> void:
	get_tree().change_scene_to_packed(level_scene)
	score_timer.start()

func check_scores() -> void:
	if current_run_score > high_score:
		high_score = current_run_score
		
	previous_run_score = current_run_score
	
func end_game() -> void:
	reset_run_score()
	load_main_menu()
