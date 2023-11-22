extends Path2D

@export var rock_scenes: Array[PackedScene] = []
@export var boulder_scenes: Array[PackedScene] = []
@onready var path_follow = $RockSpawnerPathFollow
@onready var level = $".."
@onready var rock_timer = $RockSpawnTimer
@onready var boulder_timer = $BoulderSpawnTimer
var rock_time_limit = 1
var boulder_time_limit = 2
var rng = RandomNumberGenerator.new()

func _on_rock_spawn_timer_timeout() -> void:
	var new_rock = rock_scenes[rng.randi_range(0, rock_scenes.size() - 1)].instantiate()
	path_follow.progress_ratio = randf()
	new_rock.global_position = path_follow.global_position
	level.add_child(new_rock)

func _on_boulder_spawn_timer_timeout() -> void:
	var new_boulder = boulder_scenes[rng.randi_range(0, boulder_scenes.size() - 1)].instantiate()
	path_follow.progress_ratio = randf()
	new_boulder.global_position = path_follow.global_position
	level.add_child(new_boulder)

func increase_difficulty() -> void:
	if rock_timer.wait_time != rock_time_limit:
		rock_timer.wait_time -= .25
	
	if boulder_timer.is_stopped():
		boulder_timer.start()
	else:
		if boulder_timer.wait_time != boulder_time_limit:
			boulder_timer.wait_time -= .25
