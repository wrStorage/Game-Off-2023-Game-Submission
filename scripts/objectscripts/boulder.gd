extends RigidBody2D

@export var vertical_speed = 250
var horizontal_speed = 0
var current_row = -1

func _process(delta):
	apply_impulse(Vector2(horizontal_speed, vertical_speed) * delta)

func _on_body_entered(body):
	if body.collision_layer == 1 and body.platform_row != current_row:
		if global_position. x >= body.global_position.x:
			horizontal_speed = 200
			current_row = body.platform_row
		else:
			horizontal_speed = -200
			current_row = body.platform_row
