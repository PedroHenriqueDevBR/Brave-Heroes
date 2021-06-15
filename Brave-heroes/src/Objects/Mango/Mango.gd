extends Area2D

func _on_Mango_body_entered(body: Node) -> void:
	$Animation.play("fade_out")
