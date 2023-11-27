extends Area2D

@export var vertical_speed: int = 350
@export var horizontal_bounce: int = 100
@export var vertical_bounce: int = -40
@export var min_rock_rotation: int = 10
@export var max_rock_rotation: int = 360
@onready var bounce_timer: Timer = $Bounce_Timer
@onready var despawn_timer: Timer = $Despawn_Timer
@onready var audio_player: AudioStreamPlayer2D = $RockAudioPlayer
@onready var original_mask: int = collision_mask
var default_vertical_speed: int = 350
var lava_overlapped: bool = false
var rotation_amount: int = randi_range(min_rock_rotation, max_rock_rotation)
var landed_position: float = 0
var horizontal_speed: int = 0
var offset: float = 20.0

func _physics_process(delta: float) -> void:
	if global_position.y > landed_position:
		collision_mask = original_mask
		
	if lava_overlapped == true:
		reset_speed()
		
	position.y += vertical_speed * delta
	position.x += horizontal_speed * delta
	rotation_degrees += rotation_amount * delta

func _on_body_entered(body: Node2D) -> void:
	audio_player.play()
	if body.collision_layer == Collision.PLATFORMS:
		if global_position.x >= body.global_position.x:
			horizontal_speed = horizontal_bounce
			rotation_amount = randi_range(min_rock_rotation, max_rock_rotation)
		else:
			horizontal_speed = -horizontal_bounce
			rotation_amount = -randi_range(min_rock_rotation, max_rock_rotation)
		vertical_speed = vertical_bounce
		bounce_timer.start()
		collision_mask -= Collision.PLATFORMS
		landed_position = body.global_position.y + offset
		
	if body.collision_layer == Collision.PLAYER:
		EventBus.player_hit_by_rock.emit()
		queue_free()
	
	if body.collision_layer == Collision.WALL:
		horizontal_speed = -horizontal_speed
		rotation_amount = -rotation_amount

func _on_bounce_timer_timeout() -> void:
	vertical_speed = default_vertical_speed
	
func reset_speed() -> void:
	vertical_speed = 0
	horizontal_speed = 0
	rotation_amount = 0

func _on_despawn_timer_timeout() -> void:
	queue_free()
	
func _on_rock_entered_lava(_area) -> void:
	lava_overlapped = true
	despawn_timer.start()
