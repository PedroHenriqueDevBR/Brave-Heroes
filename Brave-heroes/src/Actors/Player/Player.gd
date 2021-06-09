extends KinematicBody2D

const SPEED: = 250
const JUMP_FORCE = -550
const GRAVITY: = 1000
const UP: = Vector2.UP
const stomp_inpulse: = 500
var _velocity: = Vector2.ZERO
var is_on_wather: = false
var hp: = 2


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


func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
		var out: = linear_velocity
		out.y = -impulse
		return out


func die() -> void:
	get_tree().reload_current_scene()


func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_inpulse)


func _on_EnemyDetector_body_entered(body: Node) -> void:
	if not body.get_groups().empty():
		hp -= 1
	if hp <= 0:
		die()
