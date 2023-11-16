extends Area2D

@export var vertical_speed: int = 350
@export var horizontal_bounce: int = 100
@export var vertical_bounce: int = -40
@onready var bounce_timer = $Bounce_Timer
var rotation_amount: int = 0
var landed_position: int = 0
var horizontal_speed: int = 0

func _physics_process(delta) -> void:
	if global_position.y > landed_position:
		collision_mask = 13
	position.y += vertical_speed * delta
	position.x += horizontal_speed * delta
	rotation_degrees += rotation_amount * delta

func _on_body_entered(body) -> void:
	if body.collision_layer == 1:
		if global_position.x >= body.global_position.x:
			horizontal_speed = horizontal_bounce
			rotation_amount = 30
		else:
			horizontal_speed = -horizontal_bounce
			rotation_amount = -30
		vertical_speed = vertical_bounce
		bounce_timer.start()
		collision_mask = 12
		landed_position = body.global_position.y + 20
		
	if body.collision_layer == 4:
		body.apply_stun()
		queue_free()
	
	if body.collision_layer == 8:
		horizontal_speed *= -1

func _on_bounce_timer_timeout() -> void:
	vertical_speed = 350
