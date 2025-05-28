extends Control


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_sukuna_pressed() -> void:
	PlayerInfo.change_class(PlayerInfo.PlayerClasses.SUKUNA)
	print(PlayerInfo.current_class)

func _on_average_american_pressed() -> void:
	PlayerInfo.change_class(PlayerInfo.PlayerClasses.AVERAGE_AMERICAN)
	print(PlayerInfo.current_class)

func _on_fire_mage_pressed() -> void:
	PlayerInfo.change_class(PlayerInfo.PlayerClasses.FIREMAGE)
	print(PlayerInfo.current_class)

func _on_time_lord_pressed() -> void:
	pass # Replace with function body.
