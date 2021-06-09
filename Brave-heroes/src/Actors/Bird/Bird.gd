extends KinematicBody2D

const speed: = Vector2(0.0, 100.0)
var _velocity: = Vector2.ZERO
var flown_height: = 0;
export var max_heigth: = 100;
export var init_on_top: = true


func _ready() -> void:
	set_physics_process(false)
	if init_on_top:
		_velocity.y = speed.y
	else:
		_velocity.y = -speed.y


func _physics_process(delta: float) -> void:
	if flown_height >= max_heigth:
		_velocity  *= -1.0
		flown_height = 0
	flown_height += 1
	_velocity = move_and_slide(_velocity)


func _body_entered(body: Node) -> void:
	if body.global_position.y > get_node("PlayerDetector").global_position.y:
		return
	get_node("CollisionShape2D").disabled = true
	queue_free()
