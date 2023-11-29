extends Node2D

@export var platform_scenes: Array[PackedScene] = []
@export var easy_platform_limit: int = 30
@export var easy_medium_platform_limit: int = 100
@export var medium_platform_limit: int = 200
@export var medium_expert_platform_limit: int = 350
@onready var idol_scene: PackedScene = preload("res://scenes/objects/idol.tscn")
@onready var rock_spawner: Path2D = $RockSpawnerPath
@onready var player: CharacterBody2D = $Player
var screen_height: int = 640
var vertical_offset: int = 126
var horizontal_offset: int = 96
var platforms_between: int = 2
var platform_column_range: int = 2
var platform_row_limit: int = 3
var current_platform_level: int = 1
var new_platform_amount: int = 10
var amount_of_platforms: int = 10
var platform_generate_height: int = -640
var prev_platform_column: int = 0
var idol_row: int = 30

func _ready() -> void:
	EventBus.connect("obstacle_spawned", launch_obstacle)
	generate_platforms()
	get_tree().call_group("Camera", "shake_camera")

func _process(_delta: float) -> void:
	if player.global_position.y <= platform_generate_height:
		generate_platforms()
		platform_generate_height -= screen_height
		
	rock_spawner.global_position.y = player.global_position.y - screen_height

func create_platform(row: int) -> StaticBody2D:
	if row <= easy_platform_limit:
		return platform_scenes[randi_range(0, platform_scenes.size() - 7)].instantiate()
	elif row <= easy_medium_platform_limit:
		return platform_scenes[randi_range(0, platform_scenes.size() - 4)].instantiate()
	elif row <= medium_platform_limit:
		return platform_scenes[randi_range(0, platform_scenes.size() - 1)].instantiate()
	elif row <= medium_expert_platform_limit:
		return platform_scenes[randi_range(3, platform_scenes.size() - 1)].instantiate()
	return platform_scenes[randi_range(6, platform_scenes.size() - 1)].instantiate()
	
func flip_platform(platform: StaticBody2D, direction: float) -> void:
	platform.scale.x *= direction

func set_platform_position(platform: StaticBody2D, platform_position: Vector2) -> void:
	platform.global_position = platform_position

func add_platform(platform_row: int, platform_column: int) -> Vector2:
	var new_position: Vector2 = Vector2(platform_column * horizontal_offset, -vertical_offset * platform_row)
	var new_platform = create_platform(platform_row)
	flip_platform(new_platform, pow(-1, randi_range(0, 1)))
	set_platform_position(new_platform, new_position)
	add_child(new_platform)
	return new_position

func set_idol_position(idol: Area2D, idol_position: Vector2) -> void:
	idol.global_position = idol_position
	
func launch_obstacle(obstacle: Node2D) -> void:
	add_child(obstacle)
		
func generate_random_platforms(used_platforms: Array[int], platform_row: int) -> void:
	var extra_platforms: bool = true
	var extra_platform_chance: float = .4
	while extra_platforms:
		if randf_range(0, 1) <= extra_platform_chance and used_platforms.size() < platform_row_limit:
			var platform_column: int = randi_range(-platform_column_range, platform_column_range)
			if platform_column != prev_platform_column and !used_platforms.has(platform_column):
				add_platform(platform_row, platform_column)
				used_platforms.append(platform_column)
		else:
			extra_platforms = false

func generate_platform_path(used_platforms: Array[int], platform_row: int) -> void:
	var valid_choice: bool = false
	while(!valid_choice):
		var platform_column: int = randi_range(-platform_column_range, platform_column_range)
		if abs(prev_platform_column - platform_column) <= platforms_between and platform_column != prev_platform_column:
			var platform_position = add_platform(platform_row, platform_column)
			if platform_row % idol_row == 0:
				var new_idol: Area2D = idol_scene.instantiate()
				set_idol_position(new_idol, platform_position)
				add_child(new_idol)
			used_platforms.append(platform_column)
			valid_choice = true
			prev_platform_column = platform_column

func generate_platforms() -> void:
	for platform_row in range(current_platform_level, new_platform_amount):
		var used_platforms: Array[int] = []
		generate_platform_path(used_platforms, platform_row)
		generate_random_platforms(used_platforms, platform_row)
					
	current_platform_level = new_platform_amount
	new_platform_amount += amount_of_platforms
