extends KinematicBody2D

const SPEED: = 250
const JUMP_FORCE = -550
const GRAVITY: = 1000
const UP: = Vector2.UP
const stomp_inpulse: = 500
var _velocity: = Vector2.ZERO
export var is_on_water: = false
var hp: = 2
var mango_counter: = 0
export var time_left: = 60.0
var start_time: = 60.0

func _ready() -> void:
	start_time = time_left
	$Info/MangoCounter.text = 'Mangas: ' + String(mango_counter)


func _process(delta: float) -> void:
	time_left -= delta
	if time_left <= 0:
		die()
	var seconds = fmod(time_left, start_time)
	if seconds <= 10 and not $music_effects/timer.playing:
		time_running_out()
	$Info/Timer.text = '%02d' % [seconds]


func _physics_process(delta: float) -> void:
	if is_player_out_of_the_camera():
		die()
		
	_velocity.y += GRAVITY * delta
	
	var walk_left = Input.is_action_pressed("ui_left")
	var walk_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_just_pressed("ui_up")
	var jump_stop = Input.is_action_just_released("ui_up")
	var jump_pressed = Input.is_action_pressed("ui_up")
	var down_pressed = Input.is_action_pressed("ui_down")
	
	if walk_left:
		_velocity.x = -SPEED
	elif walk_right:
		_velocity.x = SPEED
	else:
		_velocity.x = 0
		
	if jump_pressed and is_on_water:
		_velocity.y = JUMP_FORCE * 0.5
	elif is_on_floor() and jump:
		_velocity.y = JUMP_FORCE
		$music_effects/Jump.play()
	elif not is_on_floor() and jump_stop and _velocity.y < 0:
		_velocity.y *= 0.5
	
	if is_on_water and down_pressed:
		_velocity.y *= 0.9
	elif is_on_water:
		_velocity.x *= 0.6
		_velocity.y *= 0.8
	
	play_animation(walk_left, walk_right, is_on_water)
	_velocity = move_and_slide(_velocity, UP)
	
	
func play_animation(walk_left: bool, walk_right: bool, is_on_water: bool) -> void:
	if walk_left:
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play('run')
		if is_on_water:
			$AnimatedSprite.rotation_degrees = -70
			$AnimatedSprite.play('jump')
	elif walk_right:
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play('run')
		if is_on_water:
			$AnimatedSprite.rotation_degrees = 70
			$AnimatedSprite.play('jump')
	else:
		$AnimatedSprite.play('idle')
		if is_on_water:
			$AnimatedSprite.rotation_degrees = 0
	
	if not is_on_floor() and not is_on_water:
		$AnimatedSprite.play('jump')


func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
		var out: = linear_velocity
		out.y = -impulse
		return out


func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	if area.is_in_group('Enemy'):
		_velocity = calculate_stomp_velocity(_velocity, stomp_inpulse)


func _on_EnemyDetector_body_entered(body: Node) -> void:
	if not body.get_groups().empty():
		hp -= 1
	if hp <= 0:
		die_with_audio()


func is_player_out_of_the_camera() -> bool:
	if $".".position.y > 610:
		return true
	return false


func get_mango() -> void:
	mango_counter += 1
	$Info/MangoCounter.text = 'Mangas: ' + String(mango_counter)


func die_with_audio() -> void:
	if not $music_effects/Lose.playing:
		$AnimatedSprite.visible = false
		$CollisionShape2D.disabled = true
		$EnemyDetector.visible = false
		$music_effects/Lose.play()


func time_running_out() -> void:
	$music_effects/timer.play()


func die() -> void:
	get_tree().reload_current_scene()


func _on_Lose_finished() -> void:
	die()
