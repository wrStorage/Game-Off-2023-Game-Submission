extends StaticBody2D

@onready var player: CharacterBody2D = $"../Player"

func _process(_delta) -> void:
	position.y = player.global_position.y
