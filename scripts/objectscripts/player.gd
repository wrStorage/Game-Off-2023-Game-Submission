extends CharacterBody2D

var speed: int = 250
var jump_speed: int = -550
var normal_jump_speed: int = -550
var upgrade_jump_speed: int = -700
var gravity_limit: int = 500
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fall_buffer: bool = false
var buffered_jump: bool = false
var squished: bool = false
var in_knockback: bool = false
var horizontal_knockback_strength: float = -200
var vertical_knockback_strength: float = -100
@export var stun_speed: int = 100
@export var stun_jump_speed: int = -400
@onready var stun_timer = $StunTimer
@onready var upgrade_timer = $UpgradeTimer
@onready var fall_buffer_timer = $FallBufferTimer
@onready var buffered_jump_timer = $BufferedJumpTimer
@onready var knockback_timer = $Knockback_Timer
@onready var impacting_ray = $PlayerCollisionShape/ImpactingObjectRay
@onready var animation_player = $PlayerAnimationPlayer
@onready var sprite = $PlayerCollisionShape
@onready var stun_sprite = $PlayerCollisionShape/PlayerSprite/StunSprite
@onready var audio_player = $PlayerAudioStream

func _physics_process(delta) -> void:
	if impacting_ray.is_colliding() and is_on_floor() and !squished:
		squished = true
		DeathScreen.show()
		get_tree().paused = true
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if is_on_floor() and direction == 0:
		animation_player.play("RESET")
		
	if is_on_floor() and direction != 0:
		animation_player.play("walk")
	
	if !is_on_floor():
		apply_gravity(delta)
	
	if is_on_floor() or fall_buffer:
		if Input.is_action_just_pressed("jump") or buffered_jump:
			velocity.y = jump_speed
			audio_player.play()
			animation_player.play("jump")
			fall_buffer = false
			buffered_jump = false
		
	if Input.is_action_just_pressed("jump"):
		buffered_jump = true
		buffered_jump_timer.start()
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = 0
	
	velocity.x = direction * speed
	
	if direction != 0:
		sprite.scale.x = direction
		
	var wasOnFloor = is_on_floor()
	
	if in_knockback:
		velocity.y = vertical_knockback_strength
		velocity.x = horizontal_knockback_strength * sprite.scale.x
	move_and_slide()
	
	if wasOnFloor and !is_on_floor() and velocity.y >= 0:
		fall_buffer = true
		fall_buffer_timer.start()
	
func apply_gravity(delta) -> void:
	if position.y < gravity_limit:
		velocity.y += gravity * delta
	
func apply_stun() -> void:
	in_knockback = true
	jump_speed = stun_jump_speed
	speed = stun_speed
	stun_timer.start()
	knockback_timer.start()
	stun_sprite.visible = true
	
func apply_upgrade() -> void:
	jump_speed = upgrade_jump_speed
	upgrade_timer.start()
	
func _on_stun_timer_timeout() -> void:
	jump_speed = normal_jump_speed
	speed = 250
	stun_timer.stop()
	stun_sprite.visible = false

func _on_fall_buffer_timer_timeout() -> void:
	fall_buffer = false

func _on_buffered_jump_timer_timeout() -> void:
	buffered_jump = false

func _on_upgrade_timer_timeout() -> void:
	jump_speed = normal_jump_speed
	upgrade_timer.stop()

func _on_knockback_timer_timeout():
	in_knockback = false
	knockback_timer.stop()
