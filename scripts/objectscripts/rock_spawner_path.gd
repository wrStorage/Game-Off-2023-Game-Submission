extends Path2D

@export var rock_scenes: Array[PackedScene] = []
@export var boulder_scenes: Array[PackedScene] = []
@onready var path_follow: PathFollow2D = $RockSpawnerPathFollow
@onready var rock_timer: Timer = $RockSpawnTimer
@onready var boulder_timer: Timer = $BoulderSpawnTimer
var rock_time_limit: float = 1.0
var boulder_time_limit: float = 1.0
var rock_time_decrement: float = 0.5
var boulder_time_decrement: float = 0.5

func _on_rock_spawn_timer_timeout() -> void:
	var new_rock: Area2D = rock_scenes[randi_range(0, rock_scenes.size() - 1)].instantiate()
	path_follow.progress_ratio = randf()
	new_rock.global_position = path_follow.global_position
	EventBus.obstacle_spawned.emit(new_rock)

func _on_boulder_spawn_timer_timeout() -> void:
	var new_boulder: RigidBody2D = boulder_scenes[randi_range(0, boulder_scenes.size() - 1)].instantiate()
	path_follow.progress_ratio = randf()
	new_boulder.global_position = path_follow.global_position
	EventBus.obstacle_spawned.emit(new_boulder)

func increase_difficulty() -> void:
	if rock_timer.wait_time != rock_time_limit:
		rock_timer.wait_time -= rock_time_decrement
	
	if boulder_timer.is_stopped():
		boulder_timer.start()
	else:
		if boulder_timer.wait_time != boulder_time_limit:
			boulder_timer.wait_time -= boulder_time_decrement
