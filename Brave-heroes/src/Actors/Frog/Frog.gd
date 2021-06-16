extends KinematicBody2D

const JUMP_HEIGHT: = -550.0
const gravity: = 1000.0
const UP: = Vector2.UP
var _velocity: = Vector2.ZERO


func _on_Timer_timeout() -> void:
	if is_on_floor():
		_velocity.y += JUMP_HEIGHT


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity, UP)


func _body_entered(body: Node) -> void:
	if body.global_position.y > get_node("PlayerDetector").global_position.y:
		return
	if body.is_in_group('Player'):
		$CollisionShape2D.disabled = true
		$music_effect/Die.play()


func _on_Die_finished() -> void:
	queue_free()
