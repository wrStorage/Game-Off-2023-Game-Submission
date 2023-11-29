extends RigidBody2D

@export var vertical_speed: float = 250.0
@onready var despawn_timer: Timer = $DespawnTimer
@onready var audio_player: AudioStreamPlayer2D = $BoulderAudioPlayer
var moveable: bool = true
var horizontal_speed: float = 0.0
var horizontal_force: float = 5000.0
var landed_position: float = 0
var offset: float = 20.0
var new_row: bool = true

func _physics_process(delta: float) -> void:
	if !moveable:
		freeze = true
	else:
		apply_force(Vector2(horizontal_speed, vertical_speed) * delta)
	
	if position.y > landed_position:
		new_row = true

func _on_body_entered(body: Node2D) -> void:
	if body.collision_layer == Collision.PLATFORMS and new_row:
		audio_player.play()
		new_row = false
		if global_position. x >= body.global_position.x:
			horizontal_speed = horizontal_force
		else:
			horizontal_speed = -horizontal_force
		landed_position = body.global_position.y + offset

func _on_despawn_timer_timeout() -> void:
	queue_free()

func set_movement_to_zero() -> void:
	moveable = false
