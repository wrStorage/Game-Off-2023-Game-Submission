extends Node

func _on_difficulty_timer_timeout():
	get_tree().call_group("Obstacles", "increase_difficulty")
