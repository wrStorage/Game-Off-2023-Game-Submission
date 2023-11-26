extends Area2D

@export var offset: int = -48
@export var movement_amount: Vector2 = Vector2(0, 10)

func _ready() -> void:
	position.y = position.y + offset
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", movement_amount, 1).as_relative()
	tween.tween_callback(tween_upward)

func _on_body_entered(body: Node2D) -> void:
	SfxAudioPlayer.play_idol_sfx()
	body.apply_upgrade()
	queue_free()
	
func tween_upward() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", -movement_amount, 1).as_relative()
	tween.tween_callback(tween_downward)
	
func tween_downward() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", movement_amount, 1).as_relative()
	tween.tween_callback(tween_upward)
