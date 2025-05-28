extends Control

func _ready() -> void:
	InputManager.can_escape = false
	InputManager.can_click_to_game = false
	InputManager.inputs_enabled = false
	get_tree().paused = true

func _on_continue_pressed() -> void:
	InputManager.can_escape = true
	InputManager.can_click_to_game = true
	InputManager.inputs_enabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	self.queue_free()

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
	get_tree().paused = false
	self.queue_free()

func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	get_tree().paused = false
	self.queue_free()
