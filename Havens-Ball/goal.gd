extends Area2D


@export_file("*.tcsn") var next_level_path : String

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("respawn"):
		$WinScreen.show()
		get_tree().paused = true


func _on_button_pressed() -> void:
	get_tree().paused = false
	if next_level_path != "":
			get_tree().change_scene_to_file(next_level_path)
	
