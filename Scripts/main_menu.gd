extends Control

func _ready() -> void:
	InputManager.can_click_to_game = false
	InputManager.can_escape = false

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	InputManager.can_click_to_game = true
	InputManager.can_escape = true


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()
