extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("Respwen")
	if body.has_method("respawn"):
		body.respawn()
