extends Area2D

@export var speed: int = 20
@export var max_speed: int = 160
@export var speed_increase: int = 20

func _physics_process(delta: float) -> void:
	position.y -= speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.collision_layer == Collision.PLATFORMS:
		body.get_node("DespawnTimer").start()
	elif body.collision_layer == Collision.PLAYER:
		EventBus.player_died.emit()
	elif body.collision_layer == Collision.BOULDER:
		body.set_movement_to_zero()
		body.despawn_timer.start()

func increase_difficulty() -> void:
	if speed != max_speed:
		speed += speed_increase
