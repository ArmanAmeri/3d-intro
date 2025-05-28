extends CanvasLayer


func _on_restart_button_pressed() -> void:
	InputManager.can_click_to_game = true
	InputManager.inputs_enabled = true
	get_tree().reload_current_scene()
	self.queue_free()
