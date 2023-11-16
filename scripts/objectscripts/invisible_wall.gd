extends StaticBody2D

@onready var player = $"../Player"

func _process(_delta) -> void:
	position.y = player.global_position.y
