extends Node2D

@export var platforms: Array[PackedScene] = []
@onready var idol: PackedScene = preload("res://scenes/objects/idol.tscn")
@onready var rock_spawner: Path2D = $RockSpawnerPath
@onready var player: CharacterBody2D = $Player
var screen_height: int = 640
var vertical_offset: int = 126
var horizontal_offset: int = 96
var current_platform_level: int = 1
var new_platform_amount: int = 10
var amount_of_platforms: int = 10
var platform_generate_height: int = -640
var prev_platform_choice: int = 0
var idol_row: int = 30
var easy_platform_limit: int = 30
var platform_row_limit: int = 3
const platform_choice_range: int = 2

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
		return platforms[randi_range(0, platforms.size() - 4)].instantiate()
	return platforms[randi_range(0, platforms.size() - 1)].instantiate()
	
func add_platform(platform_position: Vector2, row: int) -> void:
	var new_platform: StaticBody2D = create_platform(row)
	new_platform.scale.x *= pow(-1, randi_range(0, 1))
	new_platform.global_position = platform_position
	new_platform.platform_row = row
	add_child(new_platform)
	
func add_idol(idol_position: Vector2) -> void:
	var new_idol: Area2D = idol.instantiate()
	new_idol.global_position = idol_position
	add_child(new_idol)
		
func generate_random_platforms(used_platforms: Array[int], platform_row: int) -> void:
	var extra_platforms: bool = true
	while extra_platforms:
		if randf_range(0, 1) <= .4 and used_platforms.size() < platform_row_limit:
			var platform_choice: int = randi_range(-platform_choice_range, platform_choice_range)
			if platform_choice != prev_platform_choice and !used_platforms.has(platform_choice):
				var new_position: Vector2 = Vector2(platform_choice * horizontal_offset, -vertical_offset * platform_row)
				add_platform(new_position, platform_row)
				used_platforms.append(platform_choice)
		else:
			extra_platforms = false

func generate_platform_path(used_platforms: Array[int], platform_row: int) -> void:
	var valid_choice: bool = false
	while(!valid_choice):
		var platform_choice: int = randi_range(-platform_choice_range, platform_choice_range)
		if abs(prev_platform_choice - platform_choice) <= 2 and platform_choice != prev_platform_choice:
			var new_position: Vector2 = Vector2(platform_choice * horizontal_offset, -vertical_offset * platform_row)
			add_platform(new_position, platform_row)
			if platform_row % idol_row == 0:
				add_idol(new_position)
			used_platforms.append(platform_choice)
			valid_choice = true
			prev_platform_choice = platform_choice

func generate_platforms() -> void:
	for platform_row in range(current_platform_level, new_platform_amount):
		var used_platforms: Array[int] = []
		generate_platform_path(used_platforms, platform_row)
		generate_random_platforms(used_platforms, platform_row)
					
	current_platform_level = new_platform_amount
	new_platform_amount += amount_of_platforms

func launch_obstacle(obstacle: Node2D) -> void:
	add_child(obstacle)
	
