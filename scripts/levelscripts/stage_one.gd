extends Node2D

@export var platforms: Array[PackedScene] = []
@onready var idol: PackedScene = preload("res://scenes/objects/idol.tscn")
@onready var rock_spawner = $RockSpawnerPath
var screen_height: int = 640
var rng = RandomNumberGenerator.new()
var vertical_offset: int = 126
var horizontal_offset: int = 96
var current_platform_level: int = 1
var new_platform_amount: int = 10
var amount_of_platforms: int = 10
var platform_generate_height: int = -640
var prev_choice: int = 0
var added_idol: bool = false

func _ready() -> void:
	generate_platforms()

func _process(_delta) -> void:
	if $Player.global_position.y <= platform_generate_height:
		generate_platforms()
		platform_generate_height -= 640
		
	rock_spawner.global_position.y = $Player.global_position.y - screen_height

func add_platform(platform_position, row) -> void:
	var new_platform = platforms[rng.randi_range(0, platforms.size() - 1)].instantiate()
	new_platform.global_position = platform_position
	new_platform.platform_row = row
	add_idol(new_platform, row)
	add_child(new_platform)
	
func add_idol(platform, row):
	if row % 30 == 0 and !added_idol:
		added_idol = true
		var new_idol = idol.instantiate()
		platform.add_child(new_idol)

func generate_platforms() -> void:
	var platform_options = [-2, -1, 0, 1, 2]
	for n in range(current_platform_level, new_platform_amount):
		var valid_choice = false
		var used_platforms = []
		added_idol = false
		while(!valid_choice):
			var extra_platforms = false
			var choice = rng.randi_range(0, platform_options.size() - 1)
			if abs(prev_choice - choice) <= 2 and choice != prev_choice:
				var new_position = Vector2(platform_options[choice] * horizontal_offset, -vertical_offset * n)
				add_platform(new_position, n)
				used_platforms.append(platform_options[choice])
				valid_choice = true
				prev_choice = choice
				
				extra_platforms = true
				while extra_platforms:
					if rng.randf_range(0, 1) <= .4 and used_platforms.size() < 3:
						choice = rng.randi_range(0, platform_options.size() - 1)
						if choice != prev_choice and !used_platforms.has(platform_options[choice]):
							new_position = Vector2(platform_options[choice] * horizontal_offset, -vertical_offset * n)
							add_platform(new_position, n)
							used_platforms.append(platform_options[choice])
					else:
						extra_platforms = false
					
	current_platform_level = new_platform_amount
	new_platform_amount += amount_of_platforms
