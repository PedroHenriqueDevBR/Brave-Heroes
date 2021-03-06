extends KinematicBody2D

const speed: = Vector2(100.0, 300.0)
const gravity: = 1000.0
const UP: = Vector2.UP
var _velocity: = Vector2.ZERO
export var max_walk: = 100;
var walk_count: = 0;
export var walk_to_left: = true
var flip_h: = false


func _ready() -> void:
	set_physics_process(false)
	if walk_to_left:
		_velocity.x = -speed.x


func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if walk_count >= max_walk:
		_velocity  *= -1.0
		walk_count = 0
		flip_h = !flip_h
		$AnimatedSprite.flip_h = flip_h
	walk_count += 1
	_velocity.y = move_and_slide(_velocity, UP).y


func _body_entered(body: Node) -> void:
	if body.global_position.y > get_node("PlayerDetector").global_position.y:
		return
	if body.is_in_group('Player'):
		$CollisionShape2D.disabled = true
		$music_effect/Die.play()


func _on_Die_finished() -> void:
	queue_free()
