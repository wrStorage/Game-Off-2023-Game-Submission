extends Area2D

var offset: int = -48

# Called when the node enters the scene tree for the first time.
func _ready():
	position.y = position.y + offset

func _on_body_entered(body):
	body.apply_upgrade()
	queue_free()
