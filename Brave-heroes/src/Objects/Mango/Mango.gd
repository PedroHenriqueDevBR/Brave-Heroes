extends Area2D

func _on_Mango_body_entered(body: Node) -> void:
	if body.is_in_group('Player'):
		body.get_mango()
		$Animation.play("fade_out")
		
	
