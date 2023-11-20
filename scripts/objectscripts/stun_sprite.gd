extends Sprite2D

@onready var animation_player = $StunAnimationPlayer

func _on_visibility_changed():
	if visible:
		animation_player.play("stun")
	else:
		animation_player.stop()
