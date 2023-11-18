extends Area2D

@export var speed: int = 50
@export var max_speed: int = 160
@onready var speed_timer = $SpeedTimer
var lava_time_limit = 1

func _physics_process(delta) -> void:
	position.y -= speed * delta
	for rocks in get_overlapping_areas():
		rocks.queue_free()

func _on_body_entered(body) -> void:
	if body.collision_layer == 1:
		body.get_node("DespawnTimer").start()
	elif body.collision_layer == 4:
		DeathScreen.show()
		get_tree().paused = true
	elif body.collision_layer == 16:
		body.queue_free()

func _on_speed_timer_timeout() -> void:
	if speed != max_speed:
		speed += 5

func increase_difficulty() -> void:
	if speed_timer.wait_time != lava_time_limit:
		speed_timer.wait_time -= 1
