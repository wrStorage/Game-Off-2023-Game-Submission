extends RigidBody2D

@export var vertical_speed = 250
@onready var despawn_timer = $DespawnTimer
@onready var audio_player = $BoulderAudioPlayer
var moveable: bool = true
var horizontal_speed = 0
var current_row = -1

func _process(delta):
	if !moveable:
		freeze = true
	else:
		apply_impulse(Vector2(horizontal_speed, vertical_speed) * delta)

func _on_body_entered(body):
	if body.collision_layer == 1 and body.platform_row != current_row:
		audio_player.play()
		if global_position. x >= body.global_position.x:
			horizontal_speed = 200
			current_row = body.platform_row
		else:
			horizontal_speed = -200
			current_row = body.platform_row

func _on_despawn_timer_timeout():
	queue_free()

func set_movement_to_zero():
	moveable = false
