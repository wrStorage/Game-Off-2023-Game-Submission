extends Camera2D

@export var randomStrength: float = 30.0
@export var shakeFade: float = 5.0
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var previous_shake_offset = Vector2.ZERO

func _process(delta) -> void:
	offset -= previous_shake_offset
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
	
	var shake_offset = get_an_offset()
	offset += shake_offset
	previous_shake_offset = shake_offset

func shake_camera() -> void:
	shake_strength = randomStrength
	
func get_an_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
