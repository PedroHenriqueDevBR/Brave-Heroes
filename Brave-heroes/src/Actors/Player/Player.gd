extends KinematicBody2D

const SPEED: = 250
const JUMP_FORCE = -450
const GRAVITY: = 1000
const UP: = Vector2.UP
var _velocity: = Vector2.ZERO
var is_on_wather: = false


func _physics_process(delta: float) -> void:
	_velocity.y += GRAVITY * delta
	
	var walk_left = Input.is_action_pressed("ui_left")
	var walk_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_just_pressed("ui_up")
	var jump_stop = Input.is_action_just_released("ui_up")
	var jump_pressed = Input.is_action_pressed("ui_up")
	
	if walk_left:
		_velocity.x = -SPEED
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play('run')
	elif walk_right:
		_velocity.x = SPEED
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play('run')
	else:
		_velocity.x = 0
		$AnimatedSprite.play('idle')
		
	if jump_pressed and is_on_wather:
		_velocity.y = JUMP_FORCE * 0.5
	elif is_on_floor() and jump:
		_velocity.y = JUMP_FORCE
	elif not is_on_floor() and jump_stop and _velocity.y < 0:
		_velocity.y *= 0.5
	
	if (is_on_wather):
		_velocity.x *= 0.6
		_velocity.y *= 0.8
	_velocity = move_and_slide(_velocity, UP)
