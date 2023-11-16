extends StaticBody2D

var platform_row: int

func _on_despawn_timer_timeout() -> void:
	queue_free()
