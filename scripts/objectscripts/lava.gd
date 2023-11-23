extends Area2D

@export var speed: int = 20
@export var max_speed: int = 160
@export var speed_increase: int = 20

func _physics_process(delta) -> void:
	position.y -= speed * delta
	for rocks in get_overlapping_areas():
		if rocks.overlapped == false:
			rocks.overlapped = true
			rocks.start_despawner()
		rocks.reset_speed()

func _on_body_entered(body) -> void:
	if body.collision_layer == 1:
		body.get_node("DespawnTimer").start()
	elif body.collision_layer == 4:
		SfxAudioPlayer.play_death_sfx()
		DeathScreen.show()
		get_tree().paused = true
	elif body.collision_layer == 16:
		body.set_movement_to_zero()
		body.despawn_timer.start()

func increase_difficulty() -> void:
	if speed != max_speed:
		speed += speed_increase
