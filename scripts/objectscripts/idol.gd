extends Area2D

var offset: int = -48

func _ready() -> void:
	position.y = position.y + offset

func _on_body_entered(body) -> void:
	body.apply_upgrade()
	queue_free()
