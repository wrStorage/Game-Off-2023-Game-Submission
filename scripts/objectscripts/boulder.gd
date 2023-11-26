extends RigidBody2D

@export var vertical_speed: float = 250.0
@onready var despawn_timer: Timer = $DespawnTimer
@onready var audio_player: AudioStreamPlayer2D = $BoulderAudioPlayer
var moveable: bool = true
var horizontal_speed: float = 0.0
var horizontal_force: float = 200.0
var current_row: int = -1

func _process(delta: float):
	if !moveable:
		freeze = true
	else:
		apply_impulse(Vector2(horizontal_speed, vertical_speed) * delta)

func _on_body_entered(body: Node2D):
	if body.collision_layer == Collision.PLATFORMS and body.platform_row != current_row:
		audio_player.play()
		if global_position. x >= body.global_position.x:
			horizontal_speed = horizontal_force
			current_row = body.platform_row
		else:
			horizontal_speed = -horizontal_force
			current_row = body.platform_row

func _on_despawn_timer_timeout():
	queue_free()

func set_movement_to_zero():
	moveable = false
