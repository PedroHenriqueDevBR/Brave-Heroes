extends KinematicBody2D

const speed: = Vector2(120.0, 75.0)
const gravity: = 0.0
const UP: = Vector2.UP
var _velocity: = Vector2.ZERO
export var max_walk: = 200;
var walk_count: = 0;
export var max_height: = 40;
var height_count: = 0;
export var walk_to_left: = true


func _ready() -> void:
	set_physics_process(false)
	if walk_to_left:
		_velocity.x = -speed.x
	else:
		_velocity.x = speed.x
	_velocity.y = speed.y


func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if walk_count >= max_walk:
		_velocity.x  *= -1.0
		walk_count = 0
	if height_count >= max_height:
		_velocity.y  *= -1.0
		height_count = 0
	walk_count += 1
	height_count += 1
	_velocity.y = move_and_slide(_velocity, UP).y


func _body_entered(body: Node) -> void:
	if body.global_position.y > get_node("PlayerDetector").global_position.y:
		$CollisionShape2D.disabled = true
		queue_free()
