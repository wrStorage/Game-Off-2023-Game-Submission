extends Camera2D

@export var random_strength: float = 30.0
@export var shake_fade: float = 5.0
@onready var shake_audio: AudioStreamPlayer = $ShakePlayer
var shake_strength: float = 0.0
var previous_shake_offset: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	offset -= previous_shake_offset
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
	
	var shake_offset: Vector2 = get_an_offset()
	offset += shake_offset
	previous_shake_offset = shake_offset

func shake_camera() -> void:
	shake_audio.play()
	shake_strength = random_strength
	
func get_an_offset() -> Vector2:
	return Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
