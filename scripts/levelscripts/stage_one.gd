extends Node2D

@export var platforms: Array[PackedScene] = []
@onready var idol: PackedScene = preload("res://scenes/objects/idol.tscn")
@onready var rock_spawner = $RockSpawnerPath
@onready var player = $Player
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
var platform_options: Array[int] = [-2, -1, 0, 1, 2]

func _ready() -> void:
	GameManager.end_of_game = false
	generate_platforms()
	get_tree().call_group("Camera", "shake_camera")

func _process(_delta) -> void:
	if player.global_position.y <= platform_generate_height:
		generate_platforms()
		platform_generate_height -= screen_height
		
	rock_spawner.global_position.y = player.global_position.y - screen_height

func add_platform(platform_position: Vector2, row: int) -> void:
	var new_platform
	if row <= easy_platform_limit:
		new_platform = platforms[randi_range(0, platforms.size() - 4)].instantiate()
	else:
		new_platform = platforms[randi_range(0, platforms.size() - 1)].instantiate()
	var flip = randi_range(0,1)
	if flip:
		new_platform.scale.x *= -flip
	new_platform.global_position = platform_position
	new_platform.platform_row = row
	add_child(new_platform)
	
func add_idol(idol_position: Vector2) -> void:
	var new_idol = idol.instantiate()
	new_idol.global_position = idol_position
	add_child(new_idol)
		
func generate_random_platforms(used_platforms: Array[int], platform_row: int) -> void:
	var extra_platforms: bool = true
	while extra_platforms:
		if randf_range(0, 1) <= .4 and used_platforms.size() < 3:
			var platform_choice = randi_range(0, platform_options.size() - 1)
			if platform_choice != prev_platform_choice and !used_platforms.has(platform_options[platform_choice]):
				var new_position = Vector2(platform_options[platform_choice] * horizontal_offset, -vertical_offset * platform_row)
				add_platform(new_position, platform_row)
				used_platforms.append(platform_options[platform_choice])
		else:
			extra_platforms = false

func generate_platform_path(used_platforms: Array[int], platform_row: int) -> void:
	var valid_choice: bool = false
	while(!valid_choice):
		var platform_choice = randi_range(0, platform_options.size() - 1)
		if abs(prev_platform_choice - platform_choice) <= 2 and platform_choice != prev_platform_choice:
			var new_position = Vector2(platform_options[platform_choice] * horizontal_offset, -vertical_offset * platform_row)
			add_platform(new_position, platform_row)
			if platform_row % idol_row == 0:
				add_idol(new_position)
			used_platforms.append(platform_options[platform_choice])
			valid_choice = true
			prev_platform_choice = platform_choice

func generate_platforms() -> void:
	for platform_row in range(current_platform_level, new_platform_amount):
		var used_platforms: Array[int] = []
		generate_platform_path(used_platforms, platform_row)
		generate_random_platforms(used_platforms, platform_row)
					
	current_platform_level = new_platform_amount
	new_platform_amount += amount_of_platforms
